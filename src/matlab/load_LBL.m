function [T, out] = load_LBL(lbl_file)
% load_LBL Read a PDS3 label + associated ASCII spreadsheet.
%
% Input:
%   lbl_file - path to the .LBL file
%
% Output:
%   out      - struct with:
%              .table      table with variables named from the label
%              .data       raw table (same as .table)
%              .lbl_file   label path
%              .data_file   referenced .SCM file
%              .fields     cell array of field names
%
% The function is generic: it uses the FIELD definitions in the label
% to determine which columns to extract.

    arguments
        lbl_file (1,:) char
    end

    if ~isfile(lbl_file)
        error('Label file not found: %s', lbl_file);
    end

    label_txt = fileread(lbl_file);

    data_file = parse_data_filename(label_txt, lbl_file);
    field_names = parse_field_names(label_txt);

    if isempty(field_names)
        error('No FIELD names found in label.');
    end

    raw = read_pds_ascii_table(data_file, numel(field_names));

    if size(raw, 2) ~= numel(field_names)
        error('Column count mismatch: label has %d fields, file has %d columns.', ...
              numel(field_names), size(raw, 2));
    end

    T = raw_to_table(raw, field_names);

    out = struct();
    out.table = T;
    out.data = T;
    out.lbl_file = lbl_file;
    out.data_file = data_file;
    out.fields = field_names;
end

function data_file = parse_data_filename(label_txt, lbl_file)
    fname = regexp(label_txt, 'FILE_NAME\s*=\s*"([^"]+)"', 'tokens', 'once');
    if isempty(fname)
        fname = regexp(label_txt, '\^SPREADSHEET\s*=\s*\("([^"]+)"', 'tokens', 'once');
    end
    if isempty(fname)
        error('Could not find FILE_NAME or ^SPREADSHEET in label.');
    end
    fname = fname{1};

    [d,~,~] = fileparts(lbl_file);
    data_file = fullfile(d, fname);

    if ~isfile(data_file)
        error('Referenced data file not found: %s', data_file);
    end
end

function field_names = parse_field_names(label_txt)
    expr = 'OBJECT\s*=\s*FIELD\s*.*?NAME\s*=\s*"([^"]+)"';
    toks = regexp(label_txt, expr, 'tokens');
    field_names = cellfun(@(c)c{1}, toks, 'UniformOutput', false);

    % Make valid MATLAB identifiers but preserve originals if possible
    field_names = matlab.lang.makeValidName(field_names);
end

function raw = read_pds_ascii_table(data_file, n_fields)
    opts = detectImportOptions(data_file, 'FileType', 'text', 'Delimiter', ',');
    opts = setvaropts(opts, opts.VariableNames);
    opts.ExtraColumnsRule = 'ignore';
    opts.EmptyLineRule = 'read';

    % PDS ASCII tables often have no header row
    opts.DataLines = [1 inf];

    raw = readtable(data_file, opts, 'ReadVariableNames', false);

    % If readtable collapses things oddly, fallback to readcell
    if width(raw) ~= n_fields
        raw = readcell(data_file, 'Delimiter', ',');
        if size(raw, 2) ~= n_fields
            error('Could not parse file into %d columns.', n_fields);
        end
        raw = cell2table(raw);
    end
end

function T = raw_to_table(raw, field_names)
    if istable(raw)
        T = raw;
        T.Properties.VariableNames = field_names;
        for k = 1:width(T)
            T.(k) = convert_column(T.(k));
        end
    else
        error('Unexpected raw data type.');
    end
end

function x = convert_column(col)
    if iscell(col)
        col = string(col);
    end
    if isstring(col) || ischar(col)
        s = string(col);
        if all(strlength(strtrim(s)) == 0)
            x = s;
            return;
        end

        % Try numeric
        v = str2double(s);
        if all(~isnan(v) | ismissing(s))
            x = v;
            return;
        end

        % Try datetime
        try
            x = datetime(s, 'TimeZone', 'UTC');
            return;
        catch
        end

        x = s;
    else
        x = col;
    end
end
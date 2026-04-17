function build_metakernel_from_folder(templateFile, kernelFolder, outFile)
% build_metakernel_from_folder(templateFile, kernelFolder, outFile)
%
% templateFile : path to existing meta-kernel template (the one you showed)
% kernelFolder : folder containing the SPICE kernel files
% outFile      : output meta-kernel filename

    arguments
        templateFile (1,1) string
        kernelFolder (1,1) string
        outFile      (1,1) string
    end

    % Read the whole template
    txt = fileread(templateFile);

    % Find the KERNELS_TO_LOAD block
    startKey = 'KERNELS_TO_LOAD = (';
    startIdx = strfind(txt, startKey);
    if isempty(startIdx)
        error('Could not find "KERNELS_TO_LOAD = (" in template.');
    end
    startIdx = startIdx(1); % in case there are multiple matches

    % Find the closing parenthesis of that block (assumes first ')' after the key)
    closeIdx = startIdx + strfind(txt(startIdx:end), ')') - 1;
    if isempty(closeIdx)
        error('Could not find closing ")" for KERNELS_TO_LOAD block.');
    end
    closeIdx = closeIdx(1);

    % List files in the specified folder (non-recursive; adjust as needed)
    listing = dir(kernelFolder);
    isFile  = ~[listing.isdir];
    files   = {listing(isFile).name};

    if isempty(files)
        warning('No files found in folder "%s". Output meta-kernel will have an empty list.', kernelFolder);
    end

    % Build new KERNELS_TO_LOAD block
    % Use single quotes and Windows-style backslash as in your example.
    % Each line:    '$A\filename',
    lines = cell(size(files));
    for k = 1:numel(files)
        fname = files{k};
        % Escape backslashes for sprintf
        lines{k} = sprintf('    ''$A\\%s''', fname);
    end

    % Add commas to all but the last line
    if ~isempty(lines)
        for k = 1:numel(lines)-1
            lines{k} = [lines{k}, ','];
        end
    end

    % Assemble the block text
    newBlock = sprintf('%s\n%s\n%s', ...
        startKey, ...
        strjoin(lines, sprintf('\n')), ...
        '    )');

    % Replace old block with new one
    newTxt = [ ...
        txt(1:startIdx-1), ...
        newBlock, ...
        txt(closeIdx+1:end) ...
        ];

    % Write to output file
    fid = fopen(outFile, 'w');
    if fid < 0
        error('Cannot open output file "%s" for writing.', outFile);
    end
    fwrite(fid, newTxt, 'char');
    fclose(fid);

    fprintf('Meta-kernel written to: %s\n', outFile);
end

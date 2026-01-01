function time_out = convert_time(time_in, type_in, type_out, filename_metakernel)
% convert_time General time conversion using SPICE/MICE in MATLAB
%   time_out = convert_time(time_in, type_in, type_out, filename_metakernel)
%   type_in/type_out: 'ISO', 'UTC', 'ET' (ephemeris time), etc.
%   Loads metakernel, converts between time formats.
%
%   Supported types:
%     type_in:  'ISO' (ISO string), 'UTC' (UTC string), 'ET' (ephemeris time)
%     type_out: 'ISO', 'UTC', 'ET', 'JULIAN' (Julian Date string)
%
%   Requires MICE, metakernel must include leapseconds kernel (.tls)

%% SPICE KERNEL POOLING
tempPath = load_metakernel(filename_metakernel);

%% Convert input to ET (if needed)
if strcmpi(type_in, 'ET')
    et = time_in;
elseif any(strcmpi(type_in, {'ISO','UTC'}))
    et = cspice_str2et(time_in);
else
    error('Unsupported input time type: %s', type_in);
end

%% Convert ET to desired output
switch upper(type_out)
    case 'ET'
        time_out = et;
    case 'ISO'
        time_out = cspice_et2utc(et, 'ISOC', 3); % ISO calendar string
    case 'UTC'
        time_out = cspice_et2utc(et, 'C', 3);    % Standard UTC calendar string
    case 'JULIAN'
        time_out = cspice_et2utc(et, 'J', 6);    % Julian Date string
    case 'DOY'
        time_out = cspice_et2utc(et, 'D', 3);    % Day-of-year string
    otherwise
        error('Unsupported output time type: %s', type_out);
end

%% SPICE KERNEL UNLOADING
cspice_kclear;
cd(tempPath);
end

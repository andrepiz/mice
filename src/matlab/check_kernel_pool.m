function check_kernel_pool(kernel_list)

count = cspice_ktotal('ALL');  % Get total number of loaded kernels of all types

if count == 0
    error('First load the kernel pool')
end

if ~exist("kernel_list", 'var')
    for i = 1:count
        [file, filtyp, srcfil, handle, found] = cspice_kdata(i, 'ALL');
        if found
            fprintf('Kernel %d:\n File: %s\n Type: %s\n Source: %s\n Handle: %d\n\n', ...
                    i, file, filtyp, srcfil, handle);
        end
    end
else
    loaded = strings(count,1);
    for i = 1:count
        [file, ~, ~, ~, found] = cspice_kdata(i-1, 'ALL');
        if found
            loaded(i) = string(file);
        end
    end
    
    % Strip path from loaded list
    [~, loaded_name, loaded_ext] = fileparts(loaded);          % string arrays
    loaded_base = loaded_name + loaded_ext;                    % e.g. "de440.bsp"
    
    % Strip path from kernel_list as well, to be safe
    [~, want_name, want_ext] = fileparts(string(kernel_list)); % ensure string
    want_base = want_name + want_ext;
    
    for k = 1:numel(want_base)
        if any(loaded_base == want_base(k))
            fprintf('%s: LOADED\n', want_base(k));
        else
            fprintf('%s: NOT loaded\n', want_base(k));
        end
    end
end

end
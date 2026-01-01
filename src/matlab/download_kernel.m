function download_kernel(baseUrl, fileList, cygwinWget, savePath)
% downloadSpiceFiles(baseUrl, fileList, cygwinWget, savePath)
%   Downloads files using wget via Cygwin, saving in savePath.
%   baseUrl:    Base URL string
%   fileList:   Cell array of relative file paths
%   cygwinWget: Full path to Cygwin wget.exe
%   savePath:   Directory to save files

if ~isfile(cygwinWget)
    error('Cygwin wget not found: %s', cygwinWget);
end

if ~isfolder(savePath)
    mkdir(savePath);
end

origDir = pwd;
cd(savePath);

for i = 1:numel(fileList)
    relPath = fileList{i};
    relPathWeb = strrep(relPath, '\', '/');
    fullUrl = [baseUrl relPathWeb];

    wgetCmd = sprintf('"%s" -m -nH --cut-dirs=5 -e robots=off --trust-server-names -R "index.html*" -I "pub/naif/pds/data/dawn-m_a-spice-6-v1.0/dawnsp_1000/data/%s" -nv "%s"', ...
        cygwinWget, relPathWeb, fullUrl);

    status = system(wgetCmd);

    if status == 0
        fprintf('Downloaded: %s\n', fullUrl);
    else
        warning('File not found or download failed: %s', fullUrl);
    end
end

cd(origDir);

end

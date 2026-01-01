filename_metakernel = 'dawn.tm';

% Specify SPK file and object NAIF ID (e.g. for Vesta)
kernelFilepath = 'C:\Users\pizzetti\Work\mice\kernels\dawn\dawnsp_1000\data\spk\sb_vesta_110211.bsp';
kernelType = 'SPK';
objectId = 2000004; % NAIF ID for Vesta

[tVesta_start_utc, tVesta_end_utc] = check_coverage_kernel(kernelFilepath, kernelType, objectId, filename_metakernel);

% Specify SPK file and object NAIF ID (e.g. for Dawn)
kernelFilepath = 'C:\Users\pizzetti\Work\mice\kernels\dawn\dawnsp_1000\data\spk\dawn_rec_110416_110802_110913_v1.bsp';
kernelType = 'SPK';
objectId = -203; % NAIF ID for FC1

[tFC2_start_utc, tFC2_end_utc] = check_coverage_kernel(kernelFilepath, kernelType, objectId, filename_metakernel);

% Specify SPK file and object NAIF ID (e.g. for Vesta)
kernelFilepath = 'C:\Users\pizzetti\Work\mice\kernels\dawn\dawnsp_1000\data\ck\dawn_sc_110502_110508.bc';
kernelType = 'CK';
objectId = -203120; % NAIF ID for FC1

[tFrameFC2_start_utc, tFrameFC2_end_utc] = check_coverage_kernel(kernelFilepath, kernelType, objectId, filename_metakernel);

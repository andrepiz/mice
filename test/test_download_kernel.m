baseUrl = 'https://naif.jpl.nasa.gov/pub/naif/DAWN/kernels/';
fileList = { ...
    'sclk\DAWN_203_SCLKSCET.00091.tsc';
    'lsk\naif0012.tls';
    'spk\dawn_rec_110416-110802_110913_v1.bsp';
    'spk\de421.bsp';
    'spk\sb_vesta_110211.bsp';
    'spk\sb_vesta_071107.bsp';
    'spk\sb_ceres_140724.bsp';
    'spk\sb_ceres_120710.bsp';
    'spk\sb_ceres_110211.bsp';
    'ck\dawn_sc_110516_110522.bc';
    'ck\dawn_sc_110509_110515.bc';
    'ck\dawn_sc_110502_110508.bc';
    'ik\dawn_fc_v10.ti';
    'fk\dawn_v16.tf';
    'fk\dawn_vesta_v00.tf';
    'fk\dawn_ceres_v00.tf';
    'fk\dawn_fc_v3.bc';
    'pck\pck00008.tpc';
    'pck\dawn_vesta_v04.tpc';
    'pck\dawn_ceres_v06.tpc';
};
cygwinWget = 'C:\cygwin64\bin\wget.exe';
savePath = 'C:\Users\pizzetti\Work\mice\kernels\dawn';

download_kernel(baseUrl, fileList, cygwinWget, savePath)
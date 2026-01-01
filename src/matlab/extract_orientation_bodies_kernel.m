function q_ECI2REF = extract_orientation_bodies_kernel(time_UTC, bodies_list, filename_metakernel, wrtFrame, prefixId)

if ~exist('wrtFrame','var')
    wrtFrame = 'J2000';
end

%% SPICE KERNEL POOLING
tempPath = load_metakernel(filename_metakernel);

%% CONVERT DATETIME TO ET
if isnumeric(time_UTC)
    et_UTC = time_UTC;
else
    et_UTC = cspice_str2et(cellstr(datestr(time_UTC)));
end

%% READ SPICE DATA
if ~iscell(bodies_list)
    bodies_list = {bodies_list};
end
for ix = 1:length(bodies_list)
    if ~exist('prefixId','var')
        switch upper(bodies_list{ix})
            case {"52_EUROPA"
                    "ADRASTEA"
                    "AMALTHEA"
                    "ANANKE"
                    "ARIEL"
                    "ARROKOTH"
                    "ATLAS"
                    "BELINDA"
                    "BENNU"
                    "BIANCA"
                    "BORRELLY"
                    "CALLIRRHOE"
                    "CALLISTO"
                    "CALYPSO"
                    "CARME"
                    "CERES"
                    "CHALDENE"
                    "CHARON"
                    "CORDELIA"
                    "CRESSIDA"
                    "DAVIDA"
                    "DEIMOS"
                    "DESDEMONA"
                    "DESPINA"
                    "DIDYMOS"
                    "DIMORPHOS"
                    "DIONE"
                    "DONALDJOHANSON"
                    "EARTH"
                    "ELARA"
                    "ENCELADUS"
                    "EPIMETHEUS"
                    "ERINOME"
                    "EROS"
                    "EUROPA"
                    "EURYBATES"
                    "GALATEA"
                    "GANYMEDE"
                    "GASPRA"
                    "HARPALYKE"
                    "HELENE"
                    "HIMALIA"
                    "HYDRA"
                    "HYPERION"
                    "IAPETUS"
                    "IDA"
                    "IO"
                    "IOCASTE"
                    "ISONOE"
                    "ITOKAWA"
                    "JANUS"
                    "JULIET"
                    "JUPITER"
                    "KALYKE"
                    "LARISSA"
                    "LEDA"
                    "LEUCUS"
                    "LUTETIA"
                    "LYSITHEA"
                    "MAGACLITE"
                    "MARS"
                    "MENOETIUS"
                    "MERCURY"
                    "METIS"
                    "MIMAS"
                    "MIRANDA"
                    "MOON"
                    "NAIAD"
                    "NEPTUNE"
                    "NEREID"
                    "NIX"
                    "OBERON"
                    "OPHELIA"
                    "ORUS"
                    "PALLAS"
                    "PAN"
                    "PANDORA"
                    "PASIPHAE"
                    "PATROCLUS"
                    "PHOBOS"
                    "PHOEBE"
                    "PLUTO"
                    "POLYMELE"
                    "PORTIA"
                    "PRAXIDIKE"
                    "PROMETHEUS"
                    "PROTEUS"
                    "PUCK"
                    "QUETA"
                    "RHEA"
                    "ROSALIND"
                    "RYUGU"
                    "SATURN"
                    "SINOPE"
                    "STEINS"
                    "SUN"
                    "TAYGETE"
                    "TELESTO"
                    "TEMPEL_1"
                    "TETHYS"
                    "THALASSA"
                    "THEBE"
                    "THEMISTO"
                    "TITAN"
                    "TITANIA"
                    "TRITON"
                    "UMBRIEL"
                    "URANUS"
                    "VENUS"
                    "VESTA"}   
                prefixId = 'IAU_';
            otherwise
                prefixId = '';
        end
    end
    dcm_REF2ECI_temp = cspice_pxform([prefixId, bodies_list{ix}], wrtFrame, et_UTC);
    q_ECI2REF(:, :, ix) = quat_conj(dcm_to_quat(dcm_REF2ECI_temp));
end

%% SPICE KERNEL UNLOADING
cspice_kclear;
cd(tempPath);

end

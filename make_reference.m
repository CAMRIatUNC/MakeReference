function [ref]= make_reference(em_txt_file,SpecID,emiss_filter_index)
% em_txt is typially the full emission spectra downloaded from elsewhere
% em_txt is typically has two columns: wavelength and normalized emission
% SpecID represent the ID of spectrometers, 1-4 equals SpecA-D
% emiss_filter_index ==2 means dual emission filter
% emiss_filter_index ==4 means quad_emiss_filter

load ~/Documents/MATLAB/HemoCorrectionData/BasicParameters.mat;
if emiss_filter_index == 2
    emiss_filter = dual_emiss_interp;
else if emiss_filter_index == 4
        emiss_filter = quad_emiss_interp;
    end
end
emiss_filter_wave = single(emiss_filter(:,1));
emiss_filter_value = emiss_filter(:,2);

if SpecID == 1
    wavelength = WavelengthA;
end

if SpecID == 2
    wavelength = WavelengthA;
end

if SpecID == 3
    wavelength = WavelengthA;
end
if SpecID == 4
    wavelength = WavelengthA;
end

em = dlmread(em_txt_file);
em_wave = em(:,1);
em_wave_upsample = single((em_wave(1):0.1:em_wave(end))');
em_value = em(:,2);
em_upsample = interp1(em_wave,em_value,em_wave_upsample);
wave_round = round(wavelength,1);
wave_short = single(wave_round);

for i = 1:length(wave_short)
    wave_value = wave_short(i);
    if wave_value < em_wave(1)
        ref(i) = 0; filter(i) = 0;
    else
        if wave_value > em_wave(end)
            ref(i) = 0; filter(i) = 0;
        else
         index = find(em_wave_upsample == wave_value);
         ref(i) = em_upsample(index);
         index_filter = find(emiss_filter_wave == wave_value);
         filter(i) = emiss_filter_value(index_filter);
         ref(i) = ref(i) * filter(i);
        end
    end
    
end    

ref = ref';
 
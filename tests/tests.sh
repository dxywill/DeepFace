../build/bin/FaceLandmarkImg -fdir "../videos/" -ofdir "./demo_img/" -oidir "./demo_img/" -wild -q
../build/bin/FaceLandmarkVidMulti -f ../videos/multi_face.avi -q
../build/bin/FeatureExtraction -rigid -verbose -f "../videos/1815_01_008_tony_blair.avi" -of "output_features/1815_01_008_tony_blair.txt" -simalign output_features/aligned -q
../build/bin/FaceLandmarkVid -f "../videos/1815_01_008_tony_blair.avi" -f "../videos/0188_03_021_al_pacino.avi" -f "../videos/0217_03_006_alanis_morissette.avi" -f "../videos/0244_03_004_anderson_cooper.avi" -q
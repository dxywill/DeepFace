../build/bin/FaceLandmarkImg -fdir "../videos/" -ofdir "./demo_img/" -oidir "./demo_img/" -wild -q
../build/bin/FaceLandmarkVidMulti -f ../videos/multi_face.avi
../build/bin/FeatureExtraction -rigid -verbose -f "../videos/default.wmv" -of "output_features/default.txt" -simalign output_features/aligned
../build/bin/FaceLandmarkVid -f "../videos/changeLighting.wmv" -f "../videos/0188_03_021_al_pacino.avi" -f "../videos/0217_03_006_alanis_morissette.avi" -f "../videos/0244_03_004_anderson_cooper.avi"
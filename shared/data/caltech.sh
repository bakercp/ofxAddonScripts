#!/bin/bash
# set -e


# echo "Download Caltech256 Image data"
# mkdir -p $DATA_PATH/caltech
# pushd $DATA_PATH/caltech > /dev/null
#
# caltech_256_data=256_ObjectCategories
# caltech_256_data_base_url="http://www.vision.caltech.edu/Image_Datasets/Caltech256/"
# caltech_256_data_compressed_suffix=".tar"
# caltech_256_data_compressed=$caltech_256_data$caltech_256_data_compressed_suffix
#
# if ! [ -f $caltech_256_data ] && ! [ -f $caltech_256_data_compressed ]; then
#     curl -L -O --progress-bar http://www.vision.caltech.edu/Image_Datasets/Caltech256/256_ObjectCategories.tar
# fi
#
# if ! [ -d $caltech_256_data ] ; then
#   echo "Decompressing $caltech_256_data_compressed"
#   tar xf $caltech_256_data_compressed
# else
#   echo "- Exists: Skipping decompression $caltech_256_data_compressed"
# fi
#
# sample_size=10
# echo ""
# echo "Create a sample of the Caltech256 Image data with sample size ${sample_size}"
# caltech_256_Sample_data=${caltech_256_data}_Sample
# caltech_256_Sample_Flat_data=${caltech_256_data}_Sample_Flat
#
# if ! [ -d $caltech_256_Sample_data ] || [ -d $caltech_256_Sample_Flat_data]; then
#   mkdir -p $caltech_256_Sample_Flat_data
#
#   for class_name_path in $caltech_256_data/* ; do
#     class_name=`basename $class_name_path`
#     class_name_no_number=${class_name:4}
#     sample_class_name_path=$caltech_256_Sample_data/$class_name
#     samples_remaining=$sample_size
#     mkdir -p $sample_class_name_path
#     for class_image_name in $class_name_path/* ; do
#       image_name=`basename $class_image_name`
#       image_name_no_number=${image_name:4}
#       flat_image_name=${class_name_no_number}-${image_name_no_number}
#       if (( samples_remaining <= -1 )); then
#         break
#       else
#         cp -v ${class_image_name} ${sample_class_name_path}/
#         cp -v ${class_image_name} ${caltech_256_Sample_Flat_data}/$flat_image_name
#
#         #cp -v ${class_image_name} ${sample_class_name_path}/
#       fi
#       samples_remaining=$((--samples_remaining))
#     done
#   done
# else
#   echo "- Exists: Skipping decompression $caltech_256_Sample_data"
# fi
#
# popd > /dev/null



# dlib_model_base_url="http://dlib.net/files"
dlib_model_base_url="https://github.com/bakercp/ofxDlib/releases/download/models/"
dlib_model_compressed_suffix=".bz2"
dlib_models=(
  "dlib_face_recognition_resnet_model_v1.dat"
  "mmod_dog_hipsterizer.dat"
  "mmod_human_face_detector.dat"
  "resnet34_1000_imagenet_classifier.dnn"
  "shape_predictor_68_face_landmarks.dat"
)

for dlib_model in "${dlib_models[@]}"
do
  dlib_model_compressed=$dlib_model$dlib_model_compressed_suffix
  dlib_model_compressed_path=$MODELS_PATH/$dlib_model_compressed
  dlib_model_path=$MODELS_PATH/$dlib_model

  echo "Downloading: $dlib_model"

  if ! [ -f $dlib_model_path ] && ! [ -f $dlib_model_compressed_path ] ; then
    curl -L -o $dlib_model_compressed_path --progress-bar $dlib_model_base_url/$dlib_model_compressed
  else
    echo "- Exists: Skipping download $model"
  fi

  if ! [ -f $dlib_model_path ] ; then
    echo "Decompressing $dlib_model_compressed_path"
    bzip2 -d $dlib_model_compressed_path
  else
    echo "- Exists: Skipping decompression $model"
  fi

  echo ""
done
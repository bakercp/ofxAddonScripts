#!/bin/bash
set -e

# Download dlib models and media.

echo "Downloading models and data ..."

export DEBUG=true
source $( cd "$( dirname "${BASH_SOURCE[0]}" )/../.."  && pwd )/scripts/shared/paths.sh

# echo ""
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

echo ""
echo "Installing MNIST data ..."
mnist_data_base_url="http://yann.lecun.com/exdb/mnist"
mnist_data=(
  "train-images-idx3-ubyte"
  "train-labels-idx1-ubyte"
  "t10k-images-idx3-ubyte"
  "t10k-labels-idx1-ubyte"
)

MNIST_PATH=${THIS_ADDON_SHARED_DATA_PATH}/mnist
mkdir -p ${MNIST_PATH}
for mnist_datum in "${mnist_data[@]}"
do
  if ! [ -f ${MNIST_PATH}/${mnist_datum} ]; then
    curl -L --progress-bar ${mnist_data_base_url}/${mnist_datum}.gz | gunzip > ${MNIST_PATH}/${mnist_datum}
  fi
  echo "✔ ${MNIST_PATH}/${mnist_datum}"
done


echo "Installing dlib models ..."
# dlib_model_base_url="http://dlib.net/files"
dlib_model_base_url="https://github.com/bakercp/ofxDlib/releases/download/models/"
dlib_models=(
  "dlib_face_recognition_resnet_model_v1.dat"
  "mmod_dog_hipsterizer.dat"
  "mmod_human_face_detector.dat"
  "resnet34_1000_imagenet_classifier.dnn"
  "shape_predictor_68_face_landmarks.dat"
)

MODELS_PATH=${THIS_ADDON_SHARED_DATA_PATH}/models
mkdir -p ${MODELS_PATH}
for dlib_model in "${dlib_models[@]}"
do
  if ! [ -f ${MODELS_PATH}/${dlib_model} ]; then
    curl -L --progress-bar ${dlib_model_base_url}/${dlib_model}.bz2 | bunzip2 > ${MODELS_PATH}/${dlib_model}
  fi
  echo "✔ ${MODELS_PATH}/${dlib_model}"
done

echo "Installing media ..."
media=(
  "https://upload.wikimedia.org/wikipedia/commons/b/be/July_4_crowd_at_Vienna_Metro_station.jpg Crowd.jpg"
  "https://upload.wikimedia.org/wikipedia/commons/9/90/RobertCornelius.jpg"
)

MEDIA_PATH=${THIS_ADDON_SHARED_DATA_PATH}
for entry in "${media[@]}"
do
  tokens=(${entry})
  source=${tokens[0]}
  destination=${tokens[1]:-$(basename ${source})}
  if ! [ -f ${destination} ]; then
    curl -L --create-dirs -o ${destination} --progress-bar ${source}
  fi
  echo "✔ ${destination}"
done

echo "Done."

function copy_shared_data_for_examples()
{
  if [ -z "$1" ]; then
    echo "Usage: install_data_for_examples <path_to_addon>"
    return 1
  fi

  # Form the shared data path.
  addon_shared_data_path=${1}/shared/data

  for required_data in $(ls ${1}/example*/bin/data/REQUIRED_DATA.txt)
  do
    # For the example data path.
    example_data_path=$(dirname ${required_data})

    # The || [ -n "$line" ]; is to help when the last line isn't a new line char.
    while read line || [ -n "$line" ];
    do
      # Make sure the data doesn't start with a comment hash #
      # Make sure that it isn't am empty line.
      if [ "${line:0:1}" != "#"  ] && [ -n "${line// }" ]; then
        # Turn the line into an array (space delimited).
        tokens=($line)
        # Get the first token -- the source location.
        data_source=${tokens[0]}

        if [ -e ${addon_shared_data_path}/${data_source} ]; then
          rsync -Pqar ${addon_shared_data_path}/${data_source} ${example_data_path}
        else
          echo "${addon_shared_data_path}/${data_source} does not exist. Did you install the data?"
        fi
      fi
    done < $required_data
  done
  return 0
}



copy_shared_data_for_examples ../..

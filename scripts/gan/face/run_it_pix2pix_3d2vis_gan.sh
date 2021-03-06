#!/usr/bin/env bash

# check the enviroment info
nvidia-smi
PYTHON="python"

export PYTHONPATH="/home/donny/Projects/TorchCV":${PYTHONPATH}

cd ../../../

DATA_DIR="/home/donny/DataSet/GAN/3D2VIS"

MODEL_NAME="pix2pix"
CHECKPOINTS_NAME="it_pix2pix_3d2vis_gan"$2
HYPES_FILE='hypes/gan/face/it_pix2pix_3d2vis_gan.json'
MAX_EPOCH=200

LOG_DIR="./log/gan/face/"
LOG_FILE="${LOG_DIR}${CHECKPOINTS_NAME}.log"

if [[ ! -d ${LOG_DIR} ]]; then
    echo ${LOG_DIR}" not exists!!!"
    mkdir -p ${LOG_DIR}
fi


if [[ "$1"x == "train"x ]]; then
  ${PYTHON} -u main.py --hypes ${HYPES_FILE} --phase train --gpu 0 \
                       --model_name ${MODEL_NAME} --log_to_file n \
                       --data_dir ${DATA_DIR} --max_epoch ${MAX_EPOCH} \
                       --checkpoints_name ${CHECKPOINTS_NAME}  2>&1 | tee ${LOG_FILE}

elif [[ "$1"x == "resume"x ]]; then
  ${PYTHON} -u main.py --hypes ${HYPES_FILE} --phase train --gpu 0 \
                       --model_name ${MODEL_NAME} --log_to_file n \
                       --data_dir ${DATA_DIR} --max_iters ${MAX_EPOCH} \
                       --resume_continue y --resume ./checkpoints/gan/face/${CHECKPOINTS_NAME}_latest.pth \
                       --checkpoints_name ${CHECKPOINTS_NAME}  2>&1 | tee -a ${LOG_FILE}

elif [[ "$1"x == "test"x ]]; then
  ${PYTHON} -u main.py --hypes ${HYPES_FILE} --phase test --gpu 0 --log_to_file n \
                       --model_name ${MODEL_NAME} --checkpoints_name ${CHECKPOINTS_NAME} \
                       --resume ./checkpoints/gan/face/${CHECKPOINTS_NAME}_latest.pth \
                       --test_dir ${DATA_DIR}/val --out_dir test  2>&1 | tee -a ${LOG_FILE}

else
  echo "$1"x" is invalid..."
fi

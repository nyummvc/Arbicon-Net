# Arbicon-Net (Arbitrary Continuous Geometric Transformation Networks for Image Registration)
Arbicon-Net is initially described in a [NeurIPS 2019 paper](https://papers.nips.cc/paper/8602-arbicon-net-arbitrary-continuous-geometric-transformation-networks-for-image-registration).

## Dependency ##
The code is implemented using Python 3 and PyTorch 0.2. A quick installation in Anaconda:
```
conda env create -f environment.yml
```
## Getting Started ##
### Training ###
To train CNNGeo-aff in synthetic dataset please run:
```
cd scripts/
bash train_strong_random_affine_pascal.sh
```
To train Arbicon-Net in synthetic dataset please run:
```
cd scripts/
bash train_strong_random_tps_pascal.sh
```
To fine-tune the two-stage network in PF-PASCAl training set please run:
```
cd scripts/
bash train_weak_pf_pascal.sh
```
### Evaluation ###
To evaluate your model please run:
```
python eval.py --feature-extraction resnet101 --model [your model] --eval-dataset [evaluation dataset]
```
To further evaluate your model on TSS dataset please run ``utils/tss_eval/Main.m`` in MATLAB.
Trained weight could be found and downloaded [here](https://drive.google.com/open?id=1N7QikahTo99EFO6NHSW_1NmGG1svOKMq).

## Main Results ##
PF-PASCAL:
Method | PCK
- | :-: 
WeakAlign | 75.8 |
Arbicon-Net | 77.3 |

PF-Willow:
Method | PCK
- | :-: 
WeakAlign | 71.2 |
Arbicon-Net | 72.2 |

TSS:
Method | FG3D | JODS | PASC
- | :-: | :-: | :-:
WeakAlign | 90.3 | 76.4 | 56.5
Arbicon-Net | 92.5 | 76.5 | 58.5

## Acknowledgement ##
 - [[weakalign](https://github.com/ignacio-rocco/weakalign)], [[NC-Net](https://github.com/ignacio-rocco/ncnet)] by Ignacio Rocco et al.
 - [[TSS Evaluation Toolkit](https://github.com/t-taniai/TSS_CVPR2016_EvaluationKit)] by Tatsunori Taniai et al.

## Bibtex ##
If you find our paper helpful, please cite the paper.
```
@InProceedings{chen2019nips,
author = {Jianchun Chen, Lingjing Wang, Xiang Li, and Yi Fang},
title = {Arbitrary Continuous Geometric Transformation Networks for Image Registration},
booktitle = {Proceedings of the Neural Information Processing Systems (NeurIPS 2019)},
year = {2019}
}
```

This code is provided for academic use only. For any question please contact Jianchun Chen (princejackch@gmail.com).
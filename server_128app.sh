#!/bin/bash

#CUDA_VISIBLE_DEVICES=3 th MainLoadFeature.lua -feature_list ./result_128D.out -model './Results/WedMar2314:56:452016/Embedding.t715'
#CUDA_VISIBLE_DEVICES=3 th MainLoadFeature.lua -feature_list ./result_128D.out -model './Results/FriApr817:32:232016/tripletnet.best.t7' 
#CUDA_VISIBLE_DEVICES=3 th MainLoadFeature.lua -feature_list ./result_128D_shoes_tri.out -model './Results/TueApr2620:13:122016/tripletnet.best.t7' 
#CUDA_VISIBLE_DEVICES=3 th MainLoadFeature.lua -feature_list ./result_128D_fashion.out -model './Results/WedApr2714:53:202016/tripletnet.best.t7.epoch72' 
#CUDA_VISIBLE_DEVICES=0 th MainLoadFeature.lua -feature_list ./result_128D_shoes.out -model './Results/TueApr2620:13:122016/tripletnet.best.t7.epoch102' 
CUDA_VISIBLE_DEVICES=0 th MainLoadFeature.lua -feature_list ./result_128D_fashion.out -model './Results/MonMay912:40:522016/Embedding.t7tripletnet.t7166' 
#CUDA_VISIBLE_DEVICES=3 th MainLoadFeature.lua -feature_list ./result_128D_shoes.out -model './Results/ThuApr2115:34:432016/Embedding.t7best.embedding.model.t7' 

# Main Code Logic

- `model.trainer.py`, all training functions implemented in `PreMode_trainer` class, use `data_distributed_parallel_gpu` to assign and start tasks
- `model.model.py`, `create_model` function to get the model (representation + output)
    - `model.module.representation.py` and `model.module.output.py` implements the representation and output model 
- `model.module.utils.py`, search for `loss_fn` implements loss functions
- `utils.configs.py`, mainly implements how to do the split and generate train, valid and test data (org file)
- `data.Data.py` implements the dataset (how to build the graph data from raw data to be trained)

# File structure

- `data.files` storing features (precomputed) for the model
    - use `generate_feature/esm.inference.py` to generate esm feature, need to provide a csv with `uniprotID` and `sequence` column, stored in `data.files/esm.files`
    - download af2 structures in `data.files/af2.files`
    - generate MSA in `data.files/MSA`
- `parse_input_table` code to preproccess input data file (multiprocess on variant level instead of wt seq level, can be slower than expected)
- `generate_feature` code to generate feature needed for the model
- `data`, `model`, `utils` main code for the model
- `scripts` model config files and scripts to help generate the config files

# arguments from command line

## conf

path to the config file

## mode

Can be chosen from 

- train
- continue_train
    - continue from the previous checkpoint
- test
- train_and_test
    - default, first train then run test

## gpu-id

which gpu to use (only useful in single gpu training, if multigpu, then start from gpu 0)

also specifying the gpu when testing

# arguments from config file

## output_model

Choose from `model.module.output.py`, `build_output_model` function

For Regression task, change from `BinaryClassification` to `Regression`

## data_file_train_ddp_prefix

DDP for DistributedDataParallel, need this to define the training data file for each gpu

naming format: `prefix.[0-3].csv`

## data_split_fn

In `utils.configs.py`, functions start with `make_splits_train_val`

Used to split train and **valid** dataset, can be chosen from 

- "_by_uniprot_id" (protein level split)
- "" (random split)
- "_by_anno"
    - give an extra column to specify which is the train, which is the val, use an extra column `split`
- "_by_good_batch"
    - guarantee in a batch there's positive and negative samples 


## loss_fn

In `model.module.utils.py`, search for `loss_fn`

loss_fn_mapping = {
    "mse_loss": mse_loss,
    "mse_loss_weighted": mse_loss_weighted,
    "l1_loss": l1_loss,
    "binary_cross_entropy": binary_cross_entropy,
    "cross_entropy": cross_entropy,
    "kl_div": kl_div,
    "cosin_contrastive_loss": cosin_contrastive_loss,
    "euclid_contrastive_loss": euclid_contrastive_loss,
    "combined_loss": combined_loss,
    "weighted_combined_loss": WeightedCombinedLoss,
    "weighted_loss": WeightedLoss2,
    "weighted_loss_betabinomial": WeightedLoss3,
    "gaussian_loss": gaussian_loss,
    "weighted_loss_pretrain": WeightedLoss1,   
    "regression_weighted_loss": RegressionWeightedLoss,
    "GP_loss": GPLoss,
}

## model_class

Choose from ["PreMode", "PreMode_Star_CON", "PreMode_DIFF", "PreMode_SSP", "PreMode_Mask_Predict", "PreMode_Single"]

## data_type

Seems to have no impact (only used to change the initialize method. If ClinVar, use uniform initialization, if else use default)

So here ClinVar actually means pretrain

## use_sub_seq

used for mandatory use of the seq start and seq end in the data file and crop the seq in that way

## ngpus

If > 1, train on multiple gpus and do not need to specify the gpu-id

## num_save_batches

save every X batches, this also control the validation frequency

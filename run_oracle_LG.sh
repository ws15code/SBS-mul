#!/bin/bash

#
# This is supposed to be run after run.sh.
#

set -e

stage=0

. ./cmd.sh
. ./path.sh
. parse_options.sh || exit 1;

SBS_LANGUAGES="AR DT HG MD SW UR"

if [ $stage -le 0 ]; then
for L in $SBS_LANGUAGES; do
  echo "Prep oracle G for $L"
  local/sbs_format_oracle_LG.sh $L >& data/$L/format_oracle_LG.log
done
fi

# Decode with oracle G: mono
if [ $stage -le 1 ]; then
for L in $SBS_LANGUAGES; do
  graph_dir=exp/mono/$L/graph_oracle_LG
  mkdir -p $graph_dir
  utils/mkgraph.sh --mono data/$L/lang_test_oracle_LG exp/mono \
    $graph_dir >& $graph_dir/mkgraph.log

  steps/decode.sh --nj 4 --cmd "$decode_cmd" $graph_dir data/$L/eval \
    exp/mono/decode_eval_oracle_LG_$L &
done
wait
fi

# Decode with oracle G: tri1 
if [ $stage -le 2 ]; then
for L in $SBS_LANGUAGES; do
  graph_dir=exp/tri1/$L/graph_oracle_LG
  mkdir -p $graph_dir
  utils/mkgraph.sh data/$L/lang_test_oracle_LG exp/tri1 \
    $graph_dir >& $graph_dir/mkgraph.log

  steps/decode.sh --nj 4 --cmd "$decode_cmd" $graph_dir data/$L/eval \
    exp/tri1/decode_eval_oracle_LG_$L &
done
wait
fi

## Decode with oracle G: tri2a
#if [ $stage -le 3 ]; then
#for L in $SBS_LANGUAGES; do
  #graph_dir=exp/tri2a/$L/graph_oracle_LG
  #mkdir -p $graph_dir
  #utils/mkgraph.sh data/$L/lang_test_oracle_LG exp/tri2a \
    #$graph_dir >& $graph_dir/mkgraph.log

  #steps/decode.sh --nj 4 --cmd "$decode_cmd" $graph_dir data/$L/eval \
    #exp/tri2a/decode_eval_oracle_LG_$L &
#done
#wait
#fi

# Decode with oracle G: tri2b
if [ $stage -le 3 ]; then
for L in $SBS_LANGUAGES; do
  graph_dir=exp/tri2b/$L/graph_oracle_LG
  mkdir -p $graph_dir
  utils/mkgraph.sh data/$L/lang_test_oracle_LG exp/tri2b \
    $graph_dir >& $graph_dir/mkgraph.log

  steps/decode.sh --nj 4 --cmd "$decode_cmd" $graph_dir data/$L/eval \
    exp/tri2b/decode_eval_oracle_LG_$L &
done
wait
fi

# Decode with oracle G: tri3b
if [ $stage -le 4 ]; then
for L in $SBS_LANGUAGES; do
  graph_dir=exp/tri3b/$L/graph_oracle_LG
  mkdir -p $graph_dir
  utils/mkgraph.sh data/$L/lang_test_oracle_LG exp/tri3b \
    $graph_dir >& $graph_dir/mkgraph.log

  steps/decode_fmllr.sh --nj 4 --cmd "$decode_cmd" $graph_dir data/$L/dev \
    exp/tri3b/decode_dev_oracle_LG_$L &
    
  steps/decode_fmllr.sh --nj 4 --cmd "$decode_cmd" $graph_dir data/$L/eval \
    exp/tri3b/decode_eval_oracle_LG_$L &
done
wait
fi

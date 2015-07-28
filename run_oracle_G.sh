#!/bin/bash

#
# This is supposed to be run after run.sh.
#

set -e

for L in $SBS_LANGUAGES; do
  echo "Prep oracle G for $L"
  local/sbs_format_oracle_G.sh $L >& data/$L/format_oracle_G.log
done

# Decode with oracle G
for L in $SBS_LANGUAGES; do
  graph_dir=exp/mono/$L/graph_oracle_G
  mkdir -p $graph_dir
  utils/mkgraph.sh --mono data/$L/lang_test_oracle_G exp/mono \
    $graph_dir >& $graph_dir/mkgraph.log

  steps/decode.sh --nj 4 --cmd "$decode_cmd" $graph_dir data/$L/eval \
    exp/mono/decode_eval_oracle_G_$L &
done
wait

# Decode with oracle G
for L in $SBS_LANGUAGES; do
  graph_dir=exp/tri1/$L/graph_oracle_G
  mkdir -p $graph_dir
  utils/mkgraph.sh data/$L/lang_test_oracle_G exp/tri1 \
    $graph_dir >& $graph_dir/mkgraph.log

  steps/decode.sh --nj 4 --cmd "$decode_cmd" $graph_dir data/$L/eval \
    exp/tri1/decode_eval_oracle_G_$L &
done
wait

# Decode with oracle G
for L in $SBS_LANGUAGES; do
  graph_dir=exp/tri2a/$L/graph_oracle_G
  mkdir -p $graph_dir
  utils/mkgraph.sh data/$L/lang_test_oracle_G exp/tri2a \
    $graph_dir >& $graph_dir/mkgraph.log

  steps/decode.sh --nj 4 --cmd "$decode_cmd" $graph_dir data/$L/eval \
    exp/tri2a/decode_eval_oracle_G_$L &
done
wait

# Decode with oracle G
for L in $SBS_LANGUAGES; do
  graph_dir=exp/tri2b/$L/graph_oracle_G
  mkdir -p $graph_dir
  utils/mkgraph.sh data/$L/lang_test_oracle_G exp/tri2b \
    $graph_dir >& $graph_dir/mkgraph.log

  steps/decode.sh --nj 4 --cmd "$decode_cmd" $graph_dir data/$L/eval \
    exp/tri2b/decode_eval_oracle_G_$L &
done
wait

# Decode with oracle G
for L in $SBS_LANGUAGES; do
  graph_dir=exp/tri3b/$L/graph_oracle_G
  mkdir -p $graph_dir
  utils/mkgraph.sh data/$L/lang_test_oracle_G exp/tri3b \
    $graph_dir >& $graph_dir/mkgraph.log

  steps/decode_fmllr.sh --nj 4 --cmd "$decode_cmd" $graph_dir data/$L/eval \
    exp/tri3b/decode_eval_oracle_G_$L &
done
wait


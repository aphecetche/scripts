session="mch-flps"

tmux new-session -d -s "$session"

for (( n=0; n<=10; n++ ))
do
flpnumber=$((148+$n))
flpname="cern-flp$flpnumber"
echo "$flpnumber is $flpname"
tmux new-window -t $session:$((n+2)) -n $flpnumber
tmux send-keys -t $flpnumber "ssh $flpname" C-m
tmux send-keys -t $flpnumber "cd MCHToolbox/scripts" C-m
tmux send-keys -t $flpnumber "source ~/laurent/env.sh" C-m
done

tmux attach-session -t $SESSION:2

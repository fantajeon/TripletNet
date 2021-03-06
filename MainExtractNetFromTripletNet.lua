require 'TripletNet'
require 'AttentionLSTM'


network_file = './Results/TueApr2620:13:122016/Embedding.t7best.tripletnet.t7'
output_file = './Results/TueApr2620:13:122016/tripletnet.best.t7'
weight_file = './Results/TueApr2620:13:122016/Weights.t7optim.w.t7102'
n = torch.load(network_file)

if weight_file ~= nil then
    local w1 = torch.load(weight_file)
    w = n:getParameters()
    w:copy(w1)
end
torch.save(output_file, n.nets[1])

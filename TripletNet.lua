require 'nn'
require 'nngraph'
local TripletNet, parent = torch.class('nn.TripletNet', 'nn.gModule')


local function CreateTripletNet(EmbeddingNet, inputs, distMetric, postProcess)
  local embeddings = {}
  local dists = {}
  local nets = {EmbeddingNet}
  print("CreateTripleNet of EmbeddingNet #1:", EmbeddingNet)
  print("CreateTripleNet of EmbeddingNet #2:", nets)
  local num = #inputs
  for i=1,num do
      if i < num then
          nets[i+1] = nets[1]:clone('weight','bias','gradWeight','gradBias','running_mean','running_std')
      end
      embeddings[i] = nets[i](inputs[i])
  end
  local embedMain = embeddings[1]

  if postProcess then
    embedMain = postProcess(embedMain)
  end

  for i=1,num-1 do
    if postProcess then
      dists[i] = nn.View(-1,1)(distMetric:clone()({embedMain, postProcess(embeddings[i+1])}))
    else
      dists[i] = nn.View(-1,1)(distMetric:clone()({embedMain,embeddings[i+1]}))
    end

    print ("distMetric:", distMetric)
  end
  return nets, dists, embeddings
end

function TripletNet:__init(EmbeddingNet, num, distMetric, collectFeat)
--collectFeat is of for {{layerNum = number, postProcess = module}, {layerNum = number, postProcess = module}...}
    self.num = num or 3
    self.distMetric = distMetric or nn.PairwiseDistance(2)
    self.EmbeddingNet = EmbeddingNet
    self.nets = {}
    local collectFeat = collectFeat or {{layerNum = #self.EmbeddingNet}}
    local inputs = {}
    local outputs = {}
    local dists

    for i=1,self.num do
      inputs[i] = nn.Identity()()
    end

    local start_layer = 1
    local currInputs = inputs
    for f=1,#collectFeat do
        local end_layer = collectFeat[f].layerNum
        local net = EmbeddingNet:clone('weight','bias','gradWeight','gradBias','running_mean','running_std')
        --local net = nn.Sequential()
        --for l=start_layer,end_layer do
        --    net:add(self.EmbeddingNet:get(l))
        --end

        local nets, dists, embeddings = CreateTripletNet(net, currInputs, self.distMetric, collectFeat[f].postProcess)
        currInputs = {}
        for i=1,self.num do
            if not self.nets[i] then self.nets[i] = {} end
            table.insert(self.nets[i], nets[i])
            table.insert(currInputs, embeddings[i])
        end

        print("TripletNet net:", nets)
        print("TripletNet dist:", dists)
        print("TripletNet start_layer:", start_layer, "end_layer:", end_layer)
        table.insert(outputs, nn.JoinTable(2)(dists))
        start_layer = end_layer+1
    end

    -- print("TripleNet:", outputs)
    print("TripleNet:", #collectFeat)
    print("TripleNet self.num:", self.num)
    print("TripleNet dists:", dists)
    print("TripleNet inputs:", inputs)
    print("TripleNet outputs:", outputs)

    parent.__init(self, inputs, outputs)
end

function TripletNet:shareWeights()
    for i=1,self.num-1 do
          for j=1,#self.nets[i] do
            self.nets[i+1][j]:share(self.nets[1][j],'weight','bias','gradWeight','gradBias','running_mean','running_std')
          end
    end
end


function TripletNet:type(t)
    parent.type(self, t)
    self:shareWeights()
end

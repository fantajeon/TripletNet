require 'cudnn'

local model = torch.load("./pretrained/model_19.t7")

-- 299 x 299
model.modules[#model.modules] = nil
model.modules[#model.modules] = nil
model:add( nn.ReLU(true) )
model:add( nn.Dropout(0.5) )
model:add( nn.Linear(2048,128) )
model:add( nn.ReLU(true) )
model:add( nn.Normalize(2) )

return model

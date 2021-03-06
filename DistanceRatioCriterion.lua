require 'nn'
local debugger = require('fb.debugger')

local DistanceRatioCriterion, parent = torch.class('nn.DistanceRatioCriterion', 'nn.Criterion')

-- I suggest max_value must be small(0.02~0.2), do not extreme value ie, 1.0, sqrt(2), 2. 
-- the extreme value cause overfitting
-- I guess the 128D normal volume space is too small to embed the high-dimensional feature vector 
function DistanceRatioCriterion:__init(max_value)
    parent.__init(self)
    self.SoftMax = nn.SoftMax()
    self.MSE = nn.MSECriterion()
    self.Target = torch.Tensor()
    self.MaxTargetValue = max_value or math.sqrt(2)
end

function DistanceRatioCriterion:ResetTargetValue(max_value, target_dim)
    self.MaxTargetValue = max_value
    self.Target[{{},target_dim}] = self.MaxTargetValue
end

function DistanceRatioCriterion:createTarget(input, target)
    local target = target or 1
    self.Target:resizeAs(input):typeAs(input):zero()
    self.Target[{{},target}] = self.MaxTargetValue
    --debugger.enter()
    -- target means further awawy from anchor, therefor target must be 1
end

function DistanceRatioCriterion:updateOutput(input, target_dim)
    if not self.Target:isSameSizeAs(input) then
        self:createTarget(input, target_dim)
    end

    self.Target[{{},1}] = self.MaxTargetValue
    self.Target[{{},2}] = 0
    --self.output = self.MSE:updateOutput(self.SoftMax:updateOutput(input),self.Target)
    local mask = input[{{},target_dim}]:gt(self.MaxTargetValue)
    self.Target[{{},target_dim}]:maskedCopy(mask, input[{{},target_dim}]*1.02)
    local saturedmask = input[{{},target_dim}]:gt(1.2)
    local saturedmask2 = self.Target[{{},target_dim}]:gt(1.2)
    self.Target[{{},target_dim}]:maskedCopy(saturedmask, input[{{},target_dim}])
    self.Target[{{},target_dim}]:maskedFill(saturedmask2, 1.2)
    self.output = self.MSE:updateOutput(input,self.Target)
    return self.output
end

function DistanceRatioCriterion:updateGradInput(input, target_dim)
    if not self.Target:isSameSizeAs(input) then
        self:createTarget(input, target_dim)
    end

    --self.gradInput = self.SoftMax:updateGradInput(input, self.MSE:updateGradInput(self.SoftMax.output,self.Target))
    self.gradInput  = self.MSE:updateGradInput(input,self.Target)
    return self.gradInput
end

function DistanceRatioCriterion:type(t)
    parent.type(self, t)
    self.SoftMax:type(t)
    self.MSE:type(t)
    self.Target = self.Target:type(t)
    return self
end

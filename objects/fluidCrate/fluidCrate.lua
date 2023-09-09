

function init()
end

function update(dt)
   setAnimationState()
end

function setAnimationState()
    animator.setAnimationState("interiorLiquidType","gold")
    object.setLightColor({255,0,255})  -- this is for testing
end
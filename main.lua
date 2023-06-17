local mod = RegisterMod("More pill effects", 1)

-- Initialization for each new game

function mod:init(isContinued)
    if not isContinued then

        self.storage = {
            const = {
                DAMAGE = 0.5
            },
        }

        -- update cache for each players (can be multiple like Jacob & Esau)
        for i = 0, Game():GetNumPlayers() - 1 do
            local player = Isaac.GetPlayer(i)

            self.storage[player:GetName()] = {
                damagePillMultiplier = 0
            }

            player:AddCacheFlags(CacheFlag.CACHE_ALL)
            player:EvaluateItems()
        end

    end
end

mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, mod.init)

-- Cache update

function mod:cacheUpdate(player, cacheFlag)
    if self.storage then
        if cacheFlag == CacheFlag.CACHE_DAMAGE then
            player.Damage = player.Damage + self.storage.const.DAMAGE * self.storage[player:GetName()].damagePillMultiplier
        end
    end
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.cacheUpdate)

-- global methods

function mod:damagePillEffect(player, pillEffect)
    self.storage[player:GetName()].damagePillMultiplier = self.storage[player:GetName()].damagePillMultiplier + pillEffect

    player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
    player:EvaluateItems()
end

-- Damage up pill effect

function mod:damageUpPillEffect(_, player, _)
    self:damagePillEffect(player, 1)
end

mod:AddCallback(ModCallbacks.MC_USE_PILL, mod.damageUpPillEffect, Isaac.GetPillEffectByName("Damage up!"))

-- Damage down pill effect

function mod:damageDownPillEffect(_, player, _)
    self:damagePillEffect(player, -1)
end

mod:AddCallback(ModCallbacks.MC_USE_PILL, mod.damageDownPillEffect, Isaac.GetPillEffectByName("Damage down"))

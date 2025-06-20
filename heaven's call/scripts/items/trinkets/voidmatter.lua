local mod = HeavensCall
local game = Game()
local rng = mod:GetRunRNG()
local sfx = SFXManager()

mod.ModFlags.voidMatterQueue = {}
mod:AddResetFlag(ModCallbacks.MC_POST_GAME_STARTED, "ModFlags.voidMatterQueue", {})
mod.ModFlags.voidMatterRoomIdx = -1
mod:AddResetFlag(ModCallbacks.MC_POST_GAME_STARTED, "ModFlags.voidMatterRoomIdx", -1)

function mod:OnVoidMatterNewRoom()
    if mod:SomebodyHasTrinket(mod.Trinkets.Void) then
        local room = game:GetRoom()
        local bossId = room:GetBossID()

        for _, entity in pairs(Isaac.GetRoomEntities()) do
            if entity:GetData().voidMatter then
                entity.Position = Isaac.GetPlayer(0).Position
            end
        end

        if bossId > 0 then
            local flag = true
            for _, entity in pairs(Isaac.GetRoomEntities()) do
                if flag and entity:GetBossID() == bossId and not entity:GetData().voidMatter then
                    mod:SaveBossId(bossId, entity.Type, entity.Variant, entity.SubType)
                    flag = false
                end
            end
            if flag then
                for _, entity in pairs(Isaac.GetRoomEntities()) do
                    if entity:GetBossID() > 0 then
                        mod.ModFlags.voidMatterQueue = {entity:GetBossID(), entity.Type, entity.Variant, entity.SubType}
                        break
                    end
                end
            end
            mod.ModFlags.voidMatterRoomIdx = game:GetLevel():GetCurrentRoomDesc().SafeGridIndex
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.OnVoidMatterNewRoom)

function mod:SaveBossId(bossId, tipo, variant, subtype)
    if not (
        --bossId == BossType.MOM or
        bossId == BossType.MOMS_HEART or
        bossId == BossType.IT_LIVES or
        bossId == BossType.SATAN or
        --bossId == BossType.ISAAC or
        --bossId == BossType.BLUE_BABY or
        --bossId == BossType.QQQ or
        --bossId == BossType.THE_LAMB or
        --bossId == BossType.LAMB or
        bossId == BossType.MEGA_SATAN or
        bossId == BossType.ULTRA_GREED or
        bossId == BossType.HUSH or
        bossId == BossType.DELIRIUM or
        bossId == BossType.ULTRA_GREEDIER or
        bossId == BossType.GREAT_GIDEON or
        bossId == BossType.TUFF_TWINS or
        bossId == BossType.MOTHER or
        --bossId == BossType.MOM_MAUSOLEUM or
        --bossId == BossType.MAUS_MOM or
        bossId == BossType.MOMS_HEART_MAUSOLEUM or
        --bossId == BossType.MAUS_HEART or
        bossId == BossType.DOGMA or
        --bossId == BossType.THE_BEAST or
        bossId == BossType.BEAST

        or bossId == BossType.THE_SCOURGE
        or bossId == BossType.COLOSTOMIA

    )
    then
        mod.ModFlags.voidMatterQueue = {bossId, tipo, variant, subtype}
    else
        mod.ModFlags.voidMatterQueue = {}
    end
end

function mod:OnVoidMatterBossDefeat()
    local currentroomdesc = game:GetLevel():GetCurrentRoomDesc()
    if #mod.ModFlags.voidMatterQueue > 0 and (currentroomdesc and (mod.ModFlags.voidMatterRoomIdx == currentroomdesc.SafeGridIndex)) then
        local player
        for i=0, game:GetNumPlayers ()-1 do
            local _player = game:GetPlayer(i)
            if _player and _player:HasTrinket(mod.Trinkets.Void) then 
                player = _player
                break
            end
        end
        if player then
            
            local boss = Isaac.Spawn(mod.ModFlags.voidMatterQueue[2], mod.ModFlags.voidMatterQueue[3], mod.ModFlags.voidMatterQueue[4], player.Position, Vector.Zero, player):ToNPC()
            if boss then
                boss:Morph(boss.Type, boss.Variant, boss.SubType, -1)
                boss:AddCharmed(EntityRef(player), -1)
                boss:AddEntityFlags(EntityFlag.FLAG_PERSISTENT)
                boss:GetData().voidMatter = true
                mod:TurnEntityToDelirium(boss)
                boss:Update()
                for i, entity in ipairs(Isaac.GetRoomEntities()) do
                    if entity.FrameCount == 0 and entity:IsBoss() then
                        entity:AddCharmed(EntityRef(player), -1)
                        entity:AddEntityFlags(EntityFlag.FLAG_PERSISTENT)
                        entity:GetData().voidMatter = true
                    end
                end
                --boss:SetColor(mod.Colors.hyperred, -1, 99, true, true)
                --boss:GetSprite().Color = mod.Colors.hyperred

                mod:scheduleForUpdate(function()
                    if boss then

                        local bossId = mod.ModFlags.voidMatterQueue[1]
                        if bossId == BossType.MOM or bossId == BossType.MOM_MAUSOLEUM then-- or bossId == BossType.MAUS_MOM then
                            boss.HitPoints = boss.HitPoints/4
                            boss.HitPoints = 1
                        elseif bossId == BossType.SATAN then
                            boss.HitPoints = boss.HitPoints/2
                        elseif bossId == BossType.ISAAC then
                            boss.HitPoints = boss.HitPoints/2
                        elseif bossId == BossType.LAMB then-- or bossId == BossType.THE_LAMB then
                            boss.HitPoints = boss.HitPoints/2
                        elseif bossId == BossType.BLUE_BABY then
                            boss.HitPoints = boss.HitPoints/2
                        end
                    end
                end, 5)
            end
        end
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, mod.OnVoidMatterBossDefeat)

function mod:TurnEntityToDelirium(entity)
    local validGfx = {'088_megamaw.png', '092_darkone.png', '093_darkone2.png', '91_megagurdy.png', 'angel.png', 'angel2.png', 'babyplum.png', 'blackglow.png', 'boss_000_bodies01.png', 'boss_000_bodies02.png', 'boss_001_larryjr.png', 'boss_004_monstro.png', 'boss_007_dukeofflies.png', 'boss_010_gemini.png', 'boss_013_steven.png', 'boss_014_famine.png', 'boss_016_widow.png', 'boss_019_pin.png', 'boss_021_gurdyjr.png', 'boss_024_blightedovum.png', 'boss_025_fistula.png', 'boss_027_peep.png', 'boss_027_peep_b.png', 'boss_027_peep_c.png', 'boss_030_gurdy.png', 'boss_032_chub.png', 'boss_035_chad.png', 'boss_036_pestilence.png', 'boss_038_husk.png', 'boss_041_thehollow.png', 'boss_045_carrionqueen.png', 'boss_047_thewretched.png', 'boss_048_loki.png', 'boss_049_monstroii.png', 'boss_051_gish.png', 'boss_052_war.png', 'boss_054_mom.png', 'boss_057_maskofinfamy.png', 'boss_059_daddylonglegs.png', 'boss_060_bloat.png', 'boss_062_scolex.png', 'boss_063_blastocyst.png', 'boss_063_blastocyst_back.png', 'boss_064_death.png', 'boss_066_conquest.png', 'boss_067_triachnid.png', 'boss_068_teratoma.png', 'boss_069_momsheart.png', 'boss_070_itlives.png', 'boss_071_lokii.png', 'boss_072_thefallen.png', 'boss_074_satanii.png', 'boss_074_satan_leg.png', 'boss_075_isaac.png', 'boss_078_bluebaby.png', 'boss_078_bluebaby_hush.png', 'boss_081_headlesshorseman.png', 'boss_082_krampus.png', 'boss_083_haunt.png', 'boss_085_dangle.png', 'boss_085_dingle.png', 'boss_088_megamaw2.png', 'boss_089_fatty.png', 'boss_090_fatty2.png', 'boss_74_satanwings.png', 'boss_78_moms guts.png', 'boss_bighorn.png', 'boss_hush.png', 'boss_matriarch.png', 'boss_ragmega.png', 'boss_sistersvis.png', 'boss_thefrail.png', 'boss_thefrail2.png', 'boss_thefrail_dirt.png', 'boss_turdling.png', 'brownie.png', 'delirium megasatan hand 3.png', 'littlehorn.png', 'megafred.png', 'megasatan.png', 'megasatan_effects.png', 'monster_237_gurgling hands.png', 'monster_237_gurgling.png', 'note.ipynb', 'polycephalus.png', 'ragman.png', 'ragman_body.png', 'ragman_rollinghead.png', 'theforsaken.png', 'thelamb.png', 'thestain.png'}

    local entityConfig = EntityConfig.GetEntity(entity.Type)
    if entityConfig and not entityConfig:HasEntityTags(EntityTag.NODELIRIUM) then
        local sprite = entity:GetSprite()
        for i, layer in ipairs(sprite:GetAllLayers()) do
            if layer then
                local path = layer:GetDefaultSpritesheetPath() --ex: "gfx/bosses/afterbirthplus/boss_bighorn.png"
                path = string.lower(path)

                local flag = false
                for i, gfx in ipairs(validGfx) do
                    if string.find(path, gfx) then
                        flag = true
                        break
                    end
                end

                if flag then
                    if string.find(path, "gfx/bosses/") then
                        path = string.gsub(path, "gfx/bosses/", "")
                        local newpath = "gfx/bosses/afterbirthplus/deliriumforms/"..path
                        sprite:ReplaceSpritesheet(i-1, newpath)
                    end
                end
            end
        end

        sprite:LoadGraphics()
    end
end
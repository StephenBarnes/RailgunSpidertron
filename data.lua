local util = require("__core__/lualib/util") -- for deepcopy

local newItem = table.deepcopy(data.raw["item-with-entity-data"]["spidertron"])
newItem.name = "railgun-spidertron"
newItem.place_result = "railgun-spidertron"
newItem.order = newItem.order .. "-2" -- Put it after the spidertron in lists.
newItem.icons = {
	{
		icon = "__base__/graphics/icons/spidertron-tintable.png",
		icon_size = 64,
		icon_mipmaps = 4,
	},
	{
		icon = "__base__/graphics/icons/spidertron-tintable-mask.png",
		icon_size = 64,
		icon_mipmaps = 4,
		tint = {r=0, g=0.267, b=0.451, a=0.8}, -- same tint as railgun ammo
	},
}

local newGun = table.deepcopy(data.raw.gun.railgun)
newGun.name = "spidertron-railgun"
newGun.hidden = true
newGun.attack_parameters.projectile_center = {0, 0.3}
newGun.attack_parameters.projectile_orientation_offset = -0.0625
newGun.attack_parameters.projectile_creation_distance = 0
-- This is offset in the direction that the spidertron is looking. Which is not necessarily the direction we're shooting in.

-- There is a major problem: the spidertron can shoot itself. Can only get like 3 shots before my spidertron dies.
-- The trigger effect is a line, with range and width, but no minimum range, so can't use that to make the trigger ignore the spidertron itself.
-- We could add a trigger target type to the railgun ammo, and then add that to EVERY OTHER ENTITY in the entire game. There can only be max 56 total trigger target types in the game.
--[[
local newTriggerType = {
	type = "trigger-target-type",
	name = "damaged-by-railgun",
}
-- Make railgun only affect stuff with this trigger target type.
data.raw.ammo["railgun-ammo"].ammo_type.action.trigger_target_mask = {"damaged-by-railgun"}
]]

-- It's probably better to just make the railgun only affect forces other than the spidertron, so it affects trees and rocks and bugs but you can shoot over your own buildings.
-- This also makes everything you own immune to your own railgun turrets, which means you can do "cheaty" stuff like building multiple layers of railgun turrets on your spaceship.
data.raw.ammo["railgun-ammo"].ammo_type.action.force = "not-same"


local newSpidertron = table.deepcopy(data.raw["spider-vehicle"]["spidertron"])
newSpidertron.name = "railgun-spidertron"
newSpidertron.guns = {"spidertron-railgun"}
newSpidertron.chain_shooting_cooldown_modifier = 1
newSpidertron.automatic_weapon_cycling = false
newSpidertron.minable.result = "railgun-spidertron"
newSpidertron.icons = newItem.icons

local newRecipe = table.deepcopy(data.raw["recipe"]["spidertron"])
newRecipe.name = "railgun-spidertron"
-- Use a loop to change rocket turret ingredient to railgun turret, in case another mod does sth like removing the fish ingredient.
for _, ingredient in pairs(newRecipe.ingredients) do
	if ingredient.name == "rocket-turret" then
		ingredient.name = "railgun-turret"
	elseif ingredient[1] == "rocket-turret" then
		ingredient[1] = "railgun-turret"
	end
end
newRecipe.icons = newItem.icons
newRecipe.results = {{type="item", name="railgun-spidertron", amount=1}}

local newTech = table.deepcopy(data.raw["technology"]["spidertron"])
newTech.name = "railgun-spidertron"
newTech.effects = {
	{
		type = "unlock-recipe",
		recipe = "railgun-spidertron"
	}
}
newTech.prerequisites = {"railgun", "spidertron"}
newTech.unit = table.deepcopy(data.raw.technology.railgun.unit) -- Make it cost the same as the railgun tech.
newTech.icons = {
	{
		icon = "__base__/graphics/technology/spidertron.png",
		icon_size = 256,
		icon_mipmaps = 4,
	},
	{
		icon = "__space-age__/graphics/technology/railgun.png",
		icon_size = 256,
		icon_mipmaps = 4,
		scale = 0.3,
		shift = {30, 45},
	}
}

data:extend({
	newItem,
	newGun,
	newSpidertron,
	newRecipe,
	newTech,
})
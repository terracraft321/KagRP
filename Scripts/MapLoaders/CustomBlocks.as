
/**
 *	Template for modders - add custom blocks by
 *		putting this file in your mod with custom
 *		logic for creating tiles in HandleCustomTile.
 *
 * 		Don't forget to check your colours don't overlap!
 *
 *		Note: don't modify this file directly, do it in a mod!
 */

namespace CMap
{
	enum CustomTiles
	{
		tile_customblockhelper = 7
	};
};

const SColor color_customblockhelper(255, 255, 210, 191); 

void HandleCustomTile(CMap@ map, int offset, SColor pixel)
{
	if (pixel == color_customblockhelper)
	{ 										
		map.SetTile(offset, CMap::tile_customblockhelper ); 
		map.RemoveTileFlag( offset, Tile::LIGHT_SOURCE );
		map.AddTileFlag( offset, Tile::BACKGROUND );
	}
}
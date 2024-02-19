class_name MapEnum

static func PhysicsLayer():
    return {
        "BLOCK_MOVEMENT": 1, #value should be bit number, 1, 2, 4, 8, 16, 32, 64, 128, 256, etc
        "BLOCK_SIGHT": 2,
        "PICKABLE_OBJECT": 4,
        "FOG": 8
    }

static func TileMapLayer():
    return {
        "FLOOR": 0,
        "FOG": 1,
    }

static func TerrainSet():
    return {
        "DEFAULT": 0,
        "FOG": 1,
    }

static func Terrain():
    return {
        "ROAD": 0,
        "WALL": 1,
        "FLOOR": 2,
    }

static func ForestTerrain():
    return {
        "GROUND": 0,
        "GRASS": 1,
        "TREE": 2,
        "DEAD_TREE": 2,
    }

static func FogTerrain():
    return {
        "UNEXPLORED": 0,
        "OUT_OF_SIGHT": 1,
        "IN_SIGHT": 2,
    }

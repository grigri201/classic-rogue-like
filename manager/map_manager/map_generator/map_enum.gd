class_name MapEnum

static func PhysicsLayer():
    return {
        "BLOCK_MOVEMENT": 1, #value should be bit number, 1, 2, 4, 8, 16, 32, 64, 128, 256, etc
        "BLOCK_SIGHT": 2,
        "PICKABLE_OBJECT": 4
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
        "FLOOR": 0,
        "WALL": 1,
    }

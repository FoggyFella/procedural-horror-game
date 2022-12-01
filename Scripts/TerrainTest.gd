extends StaticBody

var mat = preload("res://mats/material.tres")
var thing = preload("res://Scenes/thing.tscn")
var psx = preload("res://mats/psx.tres")
var tree = preload("res://Scenes/Tree.tscn")
var house_1 = preload("res://Scenes/House_1.tscn")

signal trees_placed

func _ready():
	Global.terrain = self
	randomize()
	var noise = OpenSimplexNoise.new()
	noise.seed = int(rand_range(1,10000))
	#noise.period = 100
	noise.period = 140
	noise.octaves = 6
	#noise.period = 80
	#noise.octaves = 6
	var noise_tex = noise.get_seamless_image(1000)
#	var noise_tex = NoiseTexture.new()
#	noise_tex.set_noise(noise)
	var noise_normal = NoiseTexture.new()
	noise_normal.width = 1000
	noise_normal.height = 1000
	noise_normal.set_noise(noise)
	noise_normal.seamless = true
	noise_normal.as_normalmap = true
	noise_normal.bump_strength = 8
	
	var plane_mesh = PlaneMesh.new()
	plane_mesh.size = Vector2(500,500)
	plane_mesh.subdivide_depth = 500
	plane_mesh.subdivide_width = 500
	
	var surface_tool = SurfaceTool.new()
	surface_tool.create_from(plane_mesh,0)
	var array_mesh = surface_tool.commit()
	var count = 0
	var data_tool = MeshDataTool.new()
	data_tool.create_from_surface(array_mesh,0)
	
	for i in range(data_tool.get_vertex_count()):
		count += 1
		var vertex = data_tool.get_vertex(i)
		vertex.y = noise.get_noise_3d(vertex.x,vertex.y,vertex.z) * 60
		if count == 100:
			count = 0
#			var thing_inst = thing.instance()
#			thing_inst.translation = Vector3(vertex.x+rand_range(-5,5),vertex.y + 5,vertex.z+rand_range(-5,5))
#			add_child(thing_inst)
		
		data_tool.set_vertex(i,vertex)
	for i in range(array_mesh.get_surface_count()):
		array_mesh.surface_remove(i)
	
	var orbs = 0
	while orbs < 5:
		orbs += 1
		var numbah = rand_range(0,data_tool.get_vertex_count())
		var vertex = data_tool.get_vertex(numbah)
		var thing_inst = thing.instance()
		thing_inst.translation = Vector3(vertex.x,vertex.y + 1,vertex.z)
		add_child(thing_inst)
	data_tool.commit_to_surface(array_mesh)
	surface_tool.begin(Mesh.PRIMITIVE_TRIANGLES)
	surface_tool.add_smooth_group(true)
	surface_tool.append_from(array_mesh, 0, Transform.IDENTITY)
	surface_tool.generate_normals()
	
	var mesh_inst = MeshInstance.new()
	mesh_inst.mesh = surface_tool.commit()
	mesh_inst.set_surface_material(0,mat)
	mesh_inst.create_trimesh_collision()
	mat.albedo_texture = noise_tex
	mat.normal_texture = noise_normal
	mesh_inst.name = "TerrainMesh"
	mesh_inst.get_child(0).name = "Terrain"
	add_child(mesh_inst)

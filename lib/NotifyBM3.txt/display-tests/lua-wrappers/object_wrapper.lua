SLB.using(SLB.FBTest);

function table.copy(t)
  local t2 = {}
  for k,v in pairs(t) do
    t2[k] = v
  end
  return t2
end

-- look up for `k' in list of tables `plist'
local function search (k, plist)
  for i=1, #plist do
    local v = plist[i][k]     -- try `i'-th superclass
    if v then return v end
  end
end

function createClass (arg)
    local c = {}        -- new class

    -- class will search for each method in the list of its
    -- parents (`arg' is the list of parents)
    setmetatable(c, {__index = function (t, k)
      return search(k, arg)
    end})

    -- prepare `c' to be the metatable of its instances
    c.__index = c

    -- return new class
    return c
end

function round_up_to_even(num)
    print("round_up_to_even -> Num = ", num);
	local num = math.ceil(num);

	if(num % 2 ~= 0) then
		num = num + 1;
	end

	return num;
end

function round_down_to_even(num)
    print("round_down_to_even -> Num = ", num);
	local num = math.floor(num);

	if(num % 2 ~= 0) then
		num = num - 1;
	end

	return num;
end

function is_yuv(format)
	local format = format;

	return (format - MDP_Y_CBCR_H2V2) == 0 or (format - MDP_Y_CBCR_H2V2_ADRENO) == 0 or (format - MDP_Y_CRCB_H2V2) == 0
			or (format - MDP_YCRYCB_H2V1 ) == 0 or (format - MDP_CBYCRY_H2V1 ) == 0 or (format - MDP_Y_CRCB_H2V1) == 0
			or (format - MDP_Y_CBCR_H2V1 ) == 0 or (format - MDP_Y_CRCB_H1V2 ) == 0 or (format - MDP_Y_CBCR_H1V2) == 0
			or (format - MDP_Y_CRCB_H2V2_TILE ) == 0 or (format - MDP_Y_CBCR_H2V2_TILE ) == 0 or (format - MDP_Y_CR_CB_H2V2) == 0
			or (format - MDP_Y_CR_CB_GH2V2 ) == 0 or (format - MDP_Y_CB_CR_H2V2 ) == 0 or (format - MDP_Y_CRCB_H1V1) == 0
			or (format - MDP_Y_CBCR_H1V1 ) == 0 or (format - MDP_YCRCB_H1V1 ) == 0 or (format - MDP_YCBCR_H1V1) == 0
			or (format - MDP_Y_CBCR_H2V2_VENUS) == 0;
end


function mdp_overlay_to_string(overlay)
	local result = "{";
	result = result .. string.format("%s = \"%s\",", "z_order", tostring(overlay.z_order));
	result = result .. string.format("%s = \"%s\",", "alpha", tostring(overlay.alpha));
	--result = result .. string.format("%s = \"%s\",", "transp_mask", tostring(overlay.transp_mask));
	result = result .. string.format("%s = \"%s\",", "flags", tostring(overlay.flags));
	result = result .. string.format("%s = \"%s\",", "horz_deci", tostring(overlay.horz_deci));
	result = result .. string.format("%s = \"%s\",", "vert_deci", tostring(overlay.vert_deci));
	--result = result .. string.format("%s = \"%s\",", "id", tostring(overlay.id));
	result = result .. string.format("%s = \"%s\",", "width", tostring(overlay.src.width));
	result = result .. string.format("%s = \"%s\",", "height", tostring(overlay.src.height));
	result = result .. string.format("%s = \"%s\",", "format", tostring(overlay.src.format));
	result = result .. string.format("%s = \"%s\",", "src_x", tostring(overlay.src_rect.x));
	result = result .. string.format("%s = \"%s\",", "src_y", tostring(overlay.src_rect.y));
	result = result .. string.format("%s = \"%s\",", "src_w", tostring(overlay.src_rect.w));
	result = result .. string.format("%s = \"%s\",", "src_h", tostring(overlay.src_rect.h));
	result = result .. string.format("%s = \"%s\",", "dst_x", tostring(overlay.dst_rect.x));
	result = result .. string.format("%s = \"%s\",", "dst_y", tostring(overlay.dst_rect.y));
	result = result .. string.format("%s = \"%s\",", "dst_w", tostring(overlay.dst_rect.w));
	result = result .. string.format("%s = \"%s\" ", "dst_h", tostring(overlay.dst_rect.h));
	result = result .. "}"
	return result;
end

--Table for blend_op
local blend_op_table = {};
blend_op_table["BLEND_OP_NOT_DEFINED"] = BLEND_OP_NOT_DEFINED;
blend_op_table["BLEND_OP_OPAQUE"] = BLEND_OP_OPAQUE;
blend_op_table["BLEND_OP_PREMULTIPLIED"] = BLEND_OP_PREMULTIPLIED;
blend_op_table["BLEND_OP_COVERAGE"] = BLEND_OP_COVERAGE;
blend_op_table["BLEND_OP_MAX"] = BLEND_OP_MAX;

-- Table for format
local format_table = {};
format_table["MDP_RGB_565"] = MDP_RGB_565;
format_table["MDP_XRGB_8888"] = MDP_XRGB_8888;
format_table["MDP_Y_CBCR_H2V2"] = MDP_Y_CBCR_H2V2;
format_table["MDP_Y_CBCR_H2V2_ADRENO"] = MDP_Y_CBCR_H2V2_ADRENO;
format_table["MDP_ARGB_8888"] = MDP_ARGB_8888;
format_table["MDP_RGB_888"] = MDP_RGB_888;
format_table["MDP_Y_CRCB_H2V2"] = MDP_Y_CRCB_H2V2;
format_table["MDP_YCRYCB_H2V1"] = MDP_YCRYCB_H2V1;
format_table["MDP_YCBYCR_H2V1"] = MDP_YCBYCR_H2V1;
format_table["MDP_CBYCRY_H2V1"] = MDP_CBYCRY_H2V1;
format_table["MDP_Y_CRCB_H2V1"] = MDP_Y_CRCB_H2V1;
format_table["MDP_Y_CBCR_H2V1"] = MDP_Y_CBCR_H2V1;
format_table["MDP_Y_CRCB_H1V2"] = MDP_Y_CRCB_H1V2;
format_table["MDP_Y_CBCR_H1V2"] = MDP_Y_CBCR_H1V2;
format_table["MDP_RGBA_8888"] = MDP_RGBA_8888;
format_table["MDP_BGRA_8888"] = MDP_BGRA_8888;
format_table["MDP_RGBX_8888"] = MDP_RGBX_8888;
format_table["MDP_Y_CRCB_H2V2_TILE"] = MDP_Y_CRCB_H2V2_TILE;
format_table["MDP_Y_CBCR_H2V2_TILE"] = MDP_Y_CBCR_H2V2_TILE;
format_table["MDP_Y_CR_CB_H2V2"] = MDP_Y_CR_CB_H2V2;
format_table["MDP_Y_CR_CB_GH2V2"] = MDP_Y_CR_CB_GH2V2;
format_table["MDP_Y_CB_CR_H2V2"] = MDP_Y_CB_CR_H2V2;
format_table["MDP_Y_CRCB_H1V1"] = MDP_Y_CRCB_H1V1;
format_table["MDP_Y_CBCR_H1V1"] = MDP_Y_CBCR_H1V1;
format_table["MDP_YCRCB_H1V1"] = MDP_YCRCB_H1V1;
format_table["MDP_YCBCR_H1V1"] = MDP_YCBCR_H1V1;
format_table["MDP_BGR_565"] = MDP_BGR_565;
format_table["MDP_BGR_888"] = MDP_BGR_888;
format_table["MDP_Y_CBCR_H2V2_VENUS"] = MDP_Y_CBCR_H2V2_VENUS;
format_table["MDP_BGRX_8888"] = MDP_BGRX_8888;
format_table["MDP_IMGTYPE_LIMIT"] = MDP_IMGTYPE_LIMIT;
format_table["MDP_RGB_BORDERFILL"] = MDP_RGB_BORDERFILL;

-- Table for rotations
rotation_table = {};
rotation_table[0] = MDP_ROT_NOP;
rotation_table[90] = MDP_ROT_90;
rotation_table[180] = MDP_ROT_180;
rotation_table[270] = MDP_ROT_270;
rotation_table[360] = MDP_ROT_NOP;

-- Table for flips
flip_table = {};
flip_table["LR"] = MDP_FLIP_LR;
flip_table["UD"] = MDP_FLIP_UD;
flip_table["UDLR"] = bit32.bor(MDP_FLIP_LR, MDP_FLIP_UD);
flip_table["LRUD"] = bit32.bor(MDP_FLIP_LR, MDP_FLIP_UD);

-- Table for mdp flags
local flags_table = {};
flags_table["MDP_ROT_90"] = MDP_ROT_90;
flags_table["MDP_ROT_NOP"] = MDP_ROT_NOP;
flags_table["MDP_FLIP_LR"] = MDP_FLIP_LR;
flags_table["MDP_FLIP_UD"] = MDP_FLIP_UD;
flags_table["MDP_ROT_180"] = MDP_ROT_180;
flags_table["MDP_ROT_270"] = MDP_ROT_270;
flags_table["MDSS_MDP_ROT_ONLY"] = MDSS_MDP_ROT_ONLY;
flags_table["MDP_DITHER"] = MDP_DITHER;
flags_table["MDP_BLUR"] = MDP_BLUR;
flags_table["MDP_BLEND_FG_PREMULT"] = MDP_BLEND_FG_PREMULT;
flags_table["MDP_IS_FG"] = MDP_IS_FG;
flags_table["MDP_DEINTERLACE"] = MDP_DEINTERLACE;
flags_table["MDP_SHARPENING"] = MDP_SHARPENING;
flags_table["MDP_NO_DMA_BARRIER_START"] = MDP_NO_DMA_BARRIER_START;
flags_table["MDP_NO_DMA_BARRIER_END"] = MDP_NO_DMA_BARRIER_END;
flags_table["MDP_NO_BLIT"] = MDP_NO_BLIT;
flags_table["MDP_BLIT_WITH_DMA_BARRIERS"] = MDP_BLIT_WITH_DMA_BARRIERS;
flags_table["MDP_BLIT_WITH_NO_DMA_BARRIERS"] = MDP_BLIT_WITH_NO_DMA_BARRIERS;
flags_table["MDP_BLIT_SRC_GEM"] = MDP_BLIT_SRC_GEM;
flags_table["MDP_BLIT_NON_CACHED"] = MDP_BLIT_NON_CACHED;
flags_table["MDP_DEINTERLACE_ODD"] = MDP_DEINTERLACE_ODD;
flags_table["MDP_OV_PLAY_NOWAIT"] = MDP_OV_PLAY_NOWAIT;
flags_table["MDP_SOURCE_ROTATED_90"] = MDP_SOURCE_ROTATED_90;
flags_table["MDP_OVERLAY_PP_CFG_EN"] = MDP_OVERLAY_PP_CFG_EN;
flags_table["MDP_BACKEND_COMPOSITION"] = MDP_BACKEND_COMPOSITION;
flags_table["MDP_BORDERFILL_SUPPORTED"] = MDP_BORDERFILL_SUPPORTED;
flags_table["MDP_SECURE_OVERLAY_SESSION"] = MDP_SECURE_OVERLAY_SESSION;
flags_table["MDP_OV_PIPE_FORCE_DMA"] = MDP_OV_PIPE_FORCE_DMA;
flags_table["MDP_MEMORY_ID_TYPE_FB"] = MDP_MEMORY_ID_TYPE_FB;
flags_table["MDP_DECIMATION_EN"] = MDP_DECIMATION_EN;
flags_table["MDP_TRANSP_NOP"] = MDP_TRANSP_NOP;
flags_table["MDP_ALPHA_NOP"] = MDP_ALPHA_NOP;
flags_table["MDP_FB_PAGE_PROTECTION_NONCACHED"] = MDP_FB_PAGE_PROTECTION_NONCACHED;
flags_table["MDP_FB_PAGE_PROTECTION_WRITETHROUGHCACHE"] = MDP_FB_PAGE_PROTECTION_WRITETHROUGHCACHE;
flags_table["MDP_FB_PAGE_PROTECTION_WRITEBACKCACHE"] = MDP_FB_PAGE_PROTECTION_WRITEBACKCACHE;
flags_table["MDP_FB_PAGE_PROTECTION_WRITEBACKWACACHE"] = MDP_FB_PAGE_PROTECTION_WRITEBACKWACACHE;
flags_table["MDSS_MDP_RIGHT_MIXER"] = MDSS_MDP_RIGHT_MIXER;
flags_table["MDP_BWC_EN"] = MDP_BWC_EN;
flags_table["MDP_OV_PIPE_SHARE"] = MDP_OV_PIPE_SHARE;

-- Class for object factory
ObjectFactory = {};

-- Create lists of object, sequenece is overlay, video, rotate, cursor, buffer
-- If type is not defined, by default, it is overlay type, however, on split display enabled panel
-- it will be SplitOverlay
function ObjectFactory:createObjects(parameters, fb)
    -- print("ObjectFactory:createObjects");
	local overlays = {};
	local videooverlays = {};
	local rotoverlays = {};
	local cursors = {};
	local buffers = {};
	local splitoverlay = {};
	local splitvideo = {};
	local all = {};
	local result = {};
	result["overlay"] = overlays;
	result["video"] = videooverlays;
	result["rotate"] = rotoverlays;
	result["cursor"] = cursors;
	result["buffer"] = buffers;
	result["splitoverlay"] = splitoverlay;
	result["splitvideo"] = splitvideo;
	result["all"] = all;

	for k, v in pairs(parameters) do
        if(v.ov_type == "video") then
			if(fb:getRightMaxWidth() == 0) then
				v.ov_type = "video";
			else
				v.ov_type = "splitvideo";
			end
		elseif((v.ov_type == nil) or (v.ov_type == "overlay")) then
			if(fb:getRightMaxWidth() == 0) then
				v.ov_type = "overlay";
			else
				v.ov_type = "splitoverlay";
			end
		end

		local obj_type = string.lower(v.ov_type);
		print("Overlay Type", obj_type);
		local obj = self:createObject(v, obj_type, fb);

		table.insert(result[obj_type], obj);
		table.insert(result["all"], obj);
	end

	return result["all"], result["overlay"], result["video"], result["rotate"], result["cursor"], result["buffer"], result["splitoverlay"], result["splitvideo"];
end

-- Create a single object
function ObjectFactory:createObject(parameter, obj_type, fb)
    print("ObjectFactory:createObject of type ", obj_type);
	IS_SPLIT_OVERLAY_USED = false;
	if(obj_type == "video") then
		return VideoOverlay:new(parameter, fb);
	elseif(obj_type == "rotate") then
		return RotOverlay:new(parameter, fb);
	elseif(obj_type == "overlay") then
		return Overlay:new(parameter, fb);
	elseif(obj_type == "cursor") then
		return Cursor:new(parameter, fb);
	elseif(obj_type == "buffer") then
		return BufferObject:new(parameter, fb);
	elseif(obj_type == "splitoverlay") then
		return SplitOverlay:new(parameter, fb);
	else
		return SplitVideoOverlay:new(parameter, fb);
	end

	return nil;
end

-- Base class of object on framebuffer
Object = {};

-- Create a new Object
function Object:new(obj, fb)
    -- print("Object:new");
	if(obj == nil) then
		local obj = {};
		setmetatable(obj, self);
		self.__index = self;
		return obj;
	end

	if(fb == nil) then
		print("FB is nil");
		return nil;
	end

	--Create a new list
	local obj = obj;
	--Change the prototype to simulate OOP
	setmetatable(obj, self);
	self.__index = self;

	fb:attachObject(obj);
	obj.fb = fb;

	return obj;
end

-- Clear the object, detach it from fb
function Object:clear()
    -- print("Object:clear");
	fb:detachObject(self);
end

-- Object toString
function Object:toString()
	local result = "{";
	result = result .. string.format("%s = \"%s\" ", "type", "object");
	return result .. "}";
end

-- Class for bufferobject, inherits from Object, used to handle pan display
BufferObject = Object:new();

-- Create a new BufferObject
function BufferObject:new(obj, fb)
    -- print("BufferObject:new");
	if(obj == nil) then
		local obj = {};
		setmetatable(obj, self);
		self.__index = self;
		return obj;
	end

	local obj = Object:new(obj, fb);
	setmetatable(obj, self);
	self.__index = self;

	if(obj == nil) then
		return nil;
	end

	obj.vinfo = fb:getFbVarScreenInfo();

	obj.color = obj.color or 0;

	obj.format = obj.format or 0;

	obj.framesize = get_frame_size(obj.format, obj.vinfo.xres, obj.vinfo.yres);

	obj.width = obj.width or obj.vinfo.xres;

	obj.height = obj.height or obj.vinfo.yres;

	obj.xoffset = obj.xoffset or 0;

	obj.yoffset = obj.yoffset or 0;

	return obj;
end

-- Call fb:drawBuffer
function BufferObject:drawBuffer()
    -- print("BufferObject:drawBuffer");
	return self.fb:drawBuffer(self.color, self.format, self.width, self.height, self.xoffset, self.yoffset);
end

-- Call fb:iopanDisplay
function BufferObject:iopanDisplay()
    -- print("BufferObject:iopanDisplay");
	return self.fb:iopanDisplay(self.vinfo);
end

function BufferObject:getHeight()
    -- print("BufferObject:getHeight");
	return self.height;
end

function BufferObject:getWidth()
    -- print("BufferObject:getWidth");
	return self.width;
end

function BufferObject:setOffset(xoffset, yoffset)
    -- print("BufferObject:setOffset");
	self.xoffset = xoffset;
	self.yoffset = yoffset;
end

-- BufferObject to String
function BufferObject:toString()
	local result = "{";
	result = result .. string.format("%s = \"%s\",", "type", "buffer");
	result = result .. string.format("%s = \"%s\",", "color", tostring(self.color));
	--result = result .. string.format("%s = \"%s\",", "framesize", tostring(self.framesize));
	result = result .. string.format("%s = \"%s\",", "xres", tostring(self.vinfo.xres));
	result = result .. string.format("%s = \"%s\",", "yres", tostring(self.vinfo.yres));
	result = result .. string.format("%s = \"%s\",", "xoffset", tostring(self.vinfo.xoffset));
	result = result .. string.format("%s = \"%s\" ", "yoffset", tostring(self.vinfo.yoffset));
	--result = result .. string.format("%s = \"%s\",", "xres_virtual", tostring(self.vinfo.xres_virtual));
	--result = result .. string.format("%s = \"%s\"", "xres_virtual", tostring(self.vinfo.xres_virtual));
	return result .. "}";
end

-- Class for Cursor, inherits from object
Cursor = Object:new();

-- Create a new Cursor object, get Cursor image
function Cursor:new(obj, fb)
    -- print("Cursor:new");
	if(obj == nil) then
		local obj = {};
		setmetatable(obj, self);
		self.__index = self;
		return obj;
	end

	local obj = Object:new(obj, fb);
	setmetatable(obj, self);
	self.__index = self;

	if(obj == nil) then
		return nil;
	end

	obj.fb_cur = fb_cursor();

	obj.set = obj.set or 0;
	obj.enable = obj.enable or 0;
	obj.rop = obj.rop or 0;
	obj.mask = obj.mask or 0;
	obj.hot_x = obj.hot_x or 0;
	obj.hot_y = obj.hot_y or 0;
	obj.dx = obj.dx or 0;
	obj.dy = obj.dy or 0;
	obj.width = obj.width or 0;
	obj.height = obj.height or 0;
	obj.fg_color = obj.fg_color or 0;
	obj.bg_color = obj.bg_color or 0;
	obj.depth = obj.depth or 0;
	obj.alpha = obj.alpha or 255;

	obj.fb_cur.set = obj.set;
	obj.fb_cur.enable = obj.enable;
	obj.fb_cur.rop = obj.rop;
	obj.fb_cur.mask = obj.mask;

	local fb_hot = obj.fb_cur.hot;
	fb_hot.x = obj.hot_x;
	fb_hot.y = obj.hot_y;
	obj.fb_cur.hot = fb_hot;

	local fb_cur_image = obj.fb_cur.image;
	fb_cur_image.dx = obj.dx;
	fb_cur_image.dy = obj.dy;
	fb_cur_image.width = obj.width;
	fb_cur_image.height = obj.height;
	fb_cur_image.fg_color = obj.fg_color;
	fb_cur_image.bg_color = obj.bg_color;
	fb_cur_image.depth = obj.depth;
	fb_cur_image.data = get_cursor_image_data(obj.alpha);
	obj.data = fb_cur_image.data;
	obj.fb_cur.image = fb_cur_image;

	obj.vinfo = fb:getFbVarScreenInfo();

	return obj;
end

-- Cursor to String
function Cursor:toString()
	local result = "{";
	result = result .. string.format("%s = \"%s\",", "type", "cursor");
	--result = result .. string.format("%s = \"%s\",", "color", tostring(self.color));
	--result = result .. string.format("%s = \"%s\",", "framesize", tostring(self.framesize));
	--result = result .. string.format("%s = \"%s\",", "set", tostring(self.fb_cur.set));
	--result = result .. string.format("%s = \"%s\",", "enable", tostring(self.fb_cur.enable));
	--result = result .. string.format("%s = \"%s\",", "rop", tostring(self.fb_cur.rop));
	result = result .. string.format("%s = \"%s\",", "dx", tostring(self.fb_cur.image.dx));
	result = result .. string.format("%s = \"%s\",", "dy", tostring(self.fb_cur.image.dx));
	result = result .. string.format("%s = \"%s\",", "width", tostring(self.fb_cur.image.width));
	result = result .. string.format("%s = \"%s\" ", "height", tostring(self.fb_cur.image.height));
	--result = result .. string.format("%s = \"%s\",", "fg_color", tostring(self.fb_cur.image.fg_color));
	--result = result .. string.format("%s = \"%s\"", "bg_color", tostring(self.fb_cur.image.bg_color));
	return result .. "}";
end

function Cursor:clear()
    -- print("Cursor:clear");
	self.fb:detachObject(self);
end

-- Call fb:iopanDisplay
function Cursor:iopanDisplay()
    -- print("Cursor:iopanDisplay");
	return self.fb:iopanDisplay(self.vinfo);
end

-- Call fb:cursor
function Cursor:cursor()
    -- print("Cursor:cursor");
	return self.fb:cursor(self);
end

function Cursor:setImagePos(dx, dy)
	print("Cursor:setImagePos x, y ", dx ,dy);
	local fb_cur_image = self.fb_cur.image;
	fb_cur_image.dx = dx;
	fb_cur_image.dy = dy;
	self.dx = dx;
	self.dy = dy;
	self.fb_cur.image = fb_cur_image;
end

function Cursor:getImagePos()
    -- print("Cursor:getImagePos");
	return self.fb_cur.image.dx, self.fb_cur.image.dy;
end

function Cursor:setWidth(width)
	print("Cursor:setWidth", width);
	local fb_cur_image = self.fb_cur.image;
	fb_cur_image.width = width;
	self.width = width;
	self.fb_cur.image = fb_cur_image;
end

function Cursor:getWidth()
	-- print("Cursor:getWidth");
    return self.fb_cur.image.width;
end

function Cursor:setHeight(height)
	print("Cursor:setHeight", height);
	local fb_cur_image = self.fb_cur.image;
	fb_cur_image.height = height;
	self.height = height;
	self.fb_cur.image = fb_cur_image;
end

function Cursor:getHeight()
    -- print("Cursor:getHeight");
	return self.fb_cur.image.height;
end

function Cursor:getImagePos()
    -- print("Cursor:getImagePos");
	return self.fb_cur.image.dx, self.fb_cur.image.dy;
end

function Cursor:getVinfo()
    -- print("Cursor:getVinfo");
	return self.vinfo;
end

function Cursor:setVinfo(vinfo)
    -- print("Cursor:setVinfo");
	self.vinfo = vinfo;
	return self.fb:putFbVarScreenInfo(vinfo);
end

function Cursor:getSet()
    -- print("Cursor:getSet");
	return self.fb_cur.set;
end

function Cursor:setSet(set)
    -- print("Cursor:setSet");
	self.fb_cur.set = set;
end

function Cursor:setEnable(enable)
    -- print("Cursor:setEnable");
	self.fb_cur.enable = enable;
end

function Cursor:getEnable()
    -- print("Cursor:getEnable");
	return self.fb_cur.enable;
end

-- AbstractOverlay is the superclass for all Overlay.
-- The is no Logic operation in AbstractOverlay, it just defines an interface
-- And parse the data passed in
AbstractOverlay = Object:new();

function AbstractOverlay:new(obj, fb)
    -- print("AbstractOverlay:new");
	if(obj == nil) then
		local obj = {};
		setmetatable(obj, self);
		self.__index = self;
		return obj;
	end

	local obj = Object:new(obj, fb);
	setmetatable(obj, self);
	self.__index = self;

	if(obj == nil) then
		return nil;
	end

	obj.blend_op = obj.blend_op or BLEND_OP_PREMULTIPLIED;
	if(type(tonumber(obj.blend_op)) ~= "number") then
		obj.blend_op = string.upper(obj.blend_op);
		obj.blend_op = blend_op_table[obj.blend_op];
	end

	obj.format = obj.format or 0;
	if(type(tonumber(obj.format)) ~= "number") then
		obj.format = string.upper(obj.format);
		obj.format = format_table[obj.format];
	end

	obj.flags = obj.flags or 0;

	if(type(tonumber(obj.flags)) ~= "number") then
		obj.flags = string.upper(obj.flags);
		obj.flags = flags_table[obj.flags];
	end

	obj.flip = obj.flip or 0;

	if(type(tonumber(obj.flip)) ~= "number") then
		obj.flip = string.upper(obj.flip);
		obj.flip = flip_table[obj.flip];
	end

	obj.format = obj.format or 0;
	obj.width = obj.width or 0;
	obj.height = obj.height or 0;

	obj.src_x = obj.src_x or 0;
	obj.src_y = obj.src_y or 0;
	obj.src_w = obj.src_w or obj.width or 0;
	obj.src_h = obj.src_h or obj.height or 0;

	obj.dst_x = obj.dst_x or 0;
	obj.dst_y = obj.dst_y or 0;
	obj.dst_w = obj.dst_w or obj.width or 0;
	obj.dst_h = obj.dst_h or obj.height or 0;

	obj.z_order = obj.z_order or 0;
	obj.alpha = obj.alpha or 255;
	obj.transp_mask = obj.transp_mask or MDP_TRANSP_NOP;
	obj.flags = obj.flags;
	obj.id = obj.id or MSMFB_NEW_REQUEST;
	obj.is_fg = obj.is_fg or 0;

	obj.horz_deci = obj.horz_deci or 0;
	obj.vert_deci = obj.vert_deci or 0;
	obj.data_offset = obj.data_offset or 0;
	obj.data_flags = obj.data_flags or 0;
	obj.show = obj.show or true;

	--obj.color = obj.color or 0;
	--
	--obj.xoffset = obj.xoffset or 0;
	--
	--obj.yoffset = obj.yoffset or 0;
	--
	--obj.set = obj.set or 0;
	--obj.enable = obj.enable or 0;
	--obj.rop = obj.rop or 0;
	--obj.mask = obj.mask or 0;
	--obj.hot_x = obj.hot_x or 0;
	--obj.hot_y = obj.hot_y or 0;
	--obj.dx = obj.dx or 0;
	--obj.dy = obj.dy or 0;
	--obj.fg_color = obj.fg_color or 0;
	--obj.bg_color = obj.bg_color or 0;
	--obj.depth = obj.depth or 0;
	--obj.alpha = obj.alpha or 255;

	return obj;
end

function AbstractOverlay:getFlip()
    -- print("AbstractOverlay:getFlip");
	return self.flip;
end

-- Set flip, can handle string input
function AbstractOverlay:setFlip(flip)
	print("AbstractOverlay:setFlip", flip);
	local flip = flip or 0;

	if(type(tonumber(flip)) ~= "number") then
		flip = string.upper(flip);
		flip = format_table[flip];
	end

	self.flip = flip;
	self:setFlags(bit32.bxor(self:getFlags(), self.flip));
end

function AbstractOverlay:getIs_fg()
    -- print("AbstractOverlay:getIs_fg");
	return self.is_fg;
end

function AbstractOverlay:setIs_fg(is_fg)
	print("AbstractOverlay:setIs_fg", is_fg);
	self.is_fg = is_fg;
end

function AbstractOverlay:getBlend_op()
    -- print("AbstractOverlay:getBlend_op");
	return self.blend_op;
end

function AbstractOverlay:setBlend_op(blend_op)
	print("AbstractOverlay:setBlend_op", blend_op);
	self.blend_op = blend_op;
end

function AbstractOverlay:setDstRectPosition(x, y)
	print("AbstractOverlay:setDstRectPosition (x,y)", x, y);
	self.dst_x = x;
	self.dst_y = y;
end

function AbstractOverlay:getDstRectPosition()
    -- print("AbstractOverlay:getDstRectPosition");
	return self.dst_x, self.dst_y;
end

function AbstractOverlay:setSrcRectPosition(x, y)
	print("AbstractOverlay:setSrcRectPosition (x,y)" ,x,y);
	self.src_x = x;
	self.src_y = y;
end

function AbstractOverlay:getSrcRectPosition()
	-- print("AbstractOverlay:getSrcRectPosition");
	return self.src_x, self.src_y;
end

function AbstractOverlay:setDstRectWidth(width)
	print("AbstractOverlay:setDstRectWidth ",width);
	self.dst_w = width;
end

function AbstractOverlay:setDstRectHeight(height)
	print("AbstractOverlay:setDstRectHeight ",height);
	self.dst_h = height;
end

function AbstractOverlay:getDstRectWidth()
	-- print("AbstractOverlay:getDstRectWidth");
	return self.dst_w;
end

function AbstractOverlay:getDstRectHeight()
	-- print("AbstractOverlay:getDstRectHeight");
	return self.dst_h;
end

function AbstractOverlay:setSrcRectWidth(width)
	print("AbstractOverlay:setSrcRectWidth", width);
	self.src_w = width;
end

function AbstractOverlay:setSrcRectHeight(height)
	print("AbstractOverlay:setSrcRectHeight",height);
	self.src_h = height;
end

function AbstractOverlay:getSrcRectWidth()
	-- print("AbstractOverlay:getSrcRectWidth");
	return self.src_w;
end

function AbstractOverlay:getSrcRectHeight()
	-- print("AbstractOverlay:getSrcRectHeight");
	return self.src_h;
end

-- set format, can handle string input
function AbstractOverlay:setFormat(format)
	print("AbstractOverlay:setFormat" , format);
	if(type(tonumber(format)) ~= "number") then
		format = string.upper(format);
		format = format_table[format];
	end

	self.format = format;
end

function AbstractOverlay:getFormat()
    -- print("AbstractOverlay:getFormat");
	return self.format;
end

-- Set overlay.src.width
function AbstractOverlay:setWidth(width)
	print("AbstractOverlay:setWidth", width);
	self.width = width;
end

-- Set overlay.src.height
function AbstractOverlay:setHeight(height)
	print("AbstractOverlay:setHeight", height);
	self.height = height;
end

-- Get overlay.src.width
function AbstractOverlay:getWidth()
    -- print("AbstractOverlay:getWidth");
	return self.width;
end

-- get overlay.src.height
function AbstractOverlay:getHeight()
    -- print("AbstractOverlay:getHeight");
	return self.height;
end

function AbstractOverlay:setZ_order(z_order)
	print("AbstractOverlay:setZ_order", z_order);
	self.z_order = z_order;
end

function AbstractOverlay:getZ_order()
    -- print("AbstractOverlay:getZ_order");
	return self.z_order;
end

function AbstractOverlay:setAlpha(alpha)
	print("AbstractOverlay:setAlpha", alpha);
	self.alpha = alpha;
end

function AbstractOverlay:getAlpha()
    -- print("AbstractOverlay:getAlpha");
	return self.alpha;
end

function AbstractOverlay:setFlags(flags)
	print("AbstractOverlay:setFlags", flags);
	local flags = flags;
	if(type(tonumber(flags)) ~= "number") then
		flags = string.upper(flags);
		flags = flags_table[flags];
	end

	self.flags = flags;
end

function AbstractOverlay:getFlags()
    -- print("AbstractOverlay:getFlags");
	return self.flags;
end

function AbstractOverlay:setId(id)
	print("AbstractOverlay:setId", id);
	self.id = id;
end

function AbstractOverlay:getId()
    -- print("AbstractOverlay:getId");
	return self.id;
end

function AbstractOverlay:setTransp_mask(transp_mask)
	print("AbstractOverlay:setTransp_mask", transp_mask);
	self.transp_mask = transp_mask;
end

function AbstractOverlay:getTransp_mask()
    -- print("AbstractOverlay:getTransp_mask");
	return self.transp_mask;
end

function AbstractOverlay:getSrc()
    -- print("AbstractOverlay:getSrc");
	return self.src;
end

function AbstractOverlay:setSrc(ov_src)
	print("AbstractOverlay:setSrc", ov_src);
	self.src = ov_src;
end

function getDestFormat(bpp)
    if (bpp == 32) then return MDP_RGBA_8888;
    elseif (bpp == 24) then return MDP_RGB_888;
    elseif (bpp == 16) then return MDP_RGB_565;
    else print("Unknown Destination format"); return -1;
    end
end
-- class for overlay, inherits from Object
-- Is the actual wrapper around mdp_overlay
Overlay = AbstractOverlay:new();

-- Create a new Overlay object
function Overlay:new(obj, fb)
    print("Overlay:new");
	if(obj == nil) then
		local obj = {};
		setmetatable(obj, self);
		self.__index = self;
		return obj;
	end

	local obj = AbstractOverlay:new(obj, fb);
	setmetatable(obj, self);
	self.__index = self;

	if(obj == nil) then
		return nil;
	end

	obj.blend_op = obj.blend_op or BLEND_OP_PREMULTIPLIED;
	if(type(tonumber(obj.blend_op)) ~= "number") then
		obj.blend_op = string.upper(obj.blend_op);
		obj.blend_op = blend_op_table[obj.blend_op];
	end

	obj.format = obj.format or 0;
	if(type(tonumber(obj.format)) ~= "number") then
		obj.format = string.upper(obj.format);
		obj.format = format_table[obj.format];
	end

	obj.flags = obj.flags or 0;
	if(type(tonumber(obj.flags)) ~= "number") then
		obj.flags = string.upper(obj.flags);
		obj.flags = flags_table[obj.flags];
	end

	if(obj.flip ~= nil and type(tonumber(obj.flip)) ~= "number") then
		obj.flip = string.upper(obj.flip);
		obj.flip = flip_table[obj.flip];
	end

	obj.ov_handle = create_overlay_handle(fb.fb_handle);
	obj.overlay = obj.ov_handle.ov;

	local ov_src = obj.overlay.src;
	ov_src.format = obj.format or 0;
	ov_src.width = obj.width or 0;
	ov_src.height = obj.height or 0;
	obj.overlay.src = ov_src;

	local ov_src_rect = obj.overlay.src_rect
	ov_src_rect.x = obj.src_x or 0;
	ov_src_rect.y = obj.src_y or 0;
	ov_src_rect.w = obj.src_w or obj.width or 0;
	ov_src_rect.h = obj.src_h or obj.height or 0;
	obj.overlay.src_rect = ov_src_rect;

	local ov_dst_rect = obj.overlay.dst_rect;
	ov_dst_rect.x = obj.dst_x or 0;
	ov_dst_rect.y = obj.dst_y or 0;
	ov_dst_rect.w = obj.dst_w or obj.width or 0;
	ov_dst_rect.h = obj.dst_h or obj.height or 0;
	obj.overlay.dst_rect = ov_dst_rect;

	obj.overlay.z_order = obj.z_order or 0;
	obj.overlay.alpha = obj.alpha or 255;
	obj.overlay.blend_op = obj.blend_op or 0;
	obj.overlay.transp_mask = obj.transp_mask or MDP_TRANSP_NOP;
	obj.overlay.flags = obj.flags;
	obj.overlay.id = obj.id or MSMFB_NEW_REQUEST;
	obj.overlay.is_fg = obj.is_fg or 0;

	if (obj.flip ~= nil) then
		obj.overlay.flags = bit32.bxor(obj.overlay.flags, obj.flip);
	end

	obj.overlay.horz_deci = obj.horz_deci or 0;
	obj.overlay.vert_deci = obj.vert_deci or 0;

	if(obj.src ~= nil) then
		local framesize = get_frame_size(obj.format, obj.width, obj.height);

		if(framesize < get_frame_size(obj.format, obj.height, obj.width)) then
			framesize = get_frame_size(obj.format, obj.height, obj.width);
		end

        if(bit32.band(obj.flags, MDP_BWC_EN) == MDP_BWC_EN) then
			framesize = framesize * 2;
		end

		obj.framesize = framesize;
	else
		obj.framesize = 0;
	end

	if(obj.framesize ~= 0) then
		print("Overlay:new:alloc_mem ", obj.framesize);
		obj.mem = alloc_mem(obj.framesize);

		if(read_file(obj.mem, obj.src, obj.framesize, 0) <= 0) then
			print("File Read : ", obj.src, " : FAILED");
			return -1;
		end

		obj.data = msmfb_overlay_data();

		local ov_data_data = obj.data.data;
		ov_data_data.memory_id = obj.mem.mem_fd;
		ov_data_data.offset = obj.data_offset or 0;
		ov_data_data.flags = obj.data_flags or 0;
		obj.data.data = ov_data_data;
	end
	if (MDP_REV <= MDP3_REV) then
		-- 8x10 (Blit Start)
		obj.req = fb.getBlitData();
		local ov_req_src = obj.req.src;
		ov_req_src.format = obj.format or 0;
		ov_req_src.width = obj.width or 0;
		ov_req_src.height = obj.height or 0;
                ov_req_src.priv = 0;
		ov_req_src.memory_id = obj.mem.mem_fd;
		ov_req_src.offset = 0;

		obj.req.src = ov_req_src;
		obj.vinfo = fb:getFbVarScreenInfo();
		local ov_req_dst = obj.req.dst;
		print("vinfo->bits_per_pixel ", obj.vinfo.bits_per_pixel , "MDP_RGBA_8888", MDP_RGBA_8888);
		ov_req_dst.format = getDestFormat(obj.vinfo.bits_per_pixel);
		ov_req_dst.width = obj.vinfo.xres;
		ov_req_dst.height = obj.vinfo.yres;

		if(obj.framesize ~= 0) then
			local destBuffSize = get_frame_size(ov_req_dst.format, ov_req_dst.height, ov_req_dst.width);
			print("Overlay:new:alloc_mem (Blit Dest)", destBuffSize);
			obj.mem_dest = alloc_mem(destBuffSize * 3);
			obj.data_blit = msmfb_overlay_data();
			print("Blit Dest obj.mem_dest.mem_fd ", obj.mem_dest.mem_fd);

			local ov_data_data = obj.data_blit.data;
			ov_data_data.memory_id = obj.mem_dest.mem_fd;
			ov_data_data.offset = obj.data_offset or 0;
			ov_data_data.flags = obj.data_flags or 0;
			obj.data_blit.data = ov_data_data;
		end

		ov_req_dst.memory_id = obj.mem_dest.mem_fd;
		ov_req_dst.offset = 0;
                ov_req_dst.priv = 0;
		obj.req.dst = ov_req_dst;
		local ov_src_rect = obj.req.src_rect;
		ov_src_rect.x = obj.src_x;
		ov_src_rect.y = obj.src_y;
		ov_src_rect.w = obj.src_w;
		ov_src_rect.h = obj.src_h;
		obj.req.src_rect = ov_src_rect;

		local ov_dst_rect = obj.req.dst_rect;
		ov_dst_rect.x = obj.dst_x;
		ov_dst_rect.y = obj.dst_y;
		print(obj.dst_w.."\n");
		ov_dst_rect.w = obj.dst_w;
		print(ov_dst_rect.w.."\n");
		ov_dst_rect.h = obj.dst_h;
		obj.req.dst_rect = ov_dst_rect;
		obj.req.alpha = obj.alpha or 255;
		obj.req.transp_mask = MDP_TRANSP_NOP;
		obj.req.flags = 0;
		print("Blit Req Src Mem Fd ", obj.req.src.memory_id, "Req Dst Mem Fd", obj.req.dst.memory_id);
		BLT_BUFF_SWAP = 0;
		-- 8x10 (Blit End)
	end
	obj.ov_handle.ov = obj.overlay;
	return obj;
end

-- Overlay to String
function Overlay:toString()
	local result = "{";
	result = result .. string.format("%s = \"%s\",", "type", "overlay");
	result = result .. string.format("%s = \"%s\" ", "source", tostring(self.src));
	--result = result .. string.format("%s = \"%s\",", "framesize", tostring(self.framesize));
	result = result .. mdp_overlay_to_string(self.overlay);
	return result .. "}";
end

function Overlay:getFlip()
    -- print("Overlay:getFlip");
	return self.flip;
end

-- Set flip, can handle string input
function Overlay:setFlip(flip)
	print("Overlay:setFlip", flip);
	local flip = flip or 0;

	if(type(tonumber(flip)) ~= "number") then
		flip = string.upper(flip);
		flip = flip_table[flip];
	end

	self.flip = flip;
	self:setFlags(bit32.bxor(self:getFlags(), self.flip));
end

function Overlay:getBlend_op()
	-- print("Overlay:getBlend_op");
    return self.blend_op;
end

-- Set blend_op, can handle string input
function Overlay:setBlend_op(blend_op)
	print("Overlay:setBlend_op", blend_op);
	local blend_op = blend_op or 0;

	if(type(tonumber(blend_op)) ~= "number") then
		blend_op = string.upper(blend_op);
		blend_op = blend_op_table[blend_op];
	end

	self.overlay.blend_op = blend_op;
	self.blend_op = blend_op;
	self.ov_handle.ov = self.overlay;
end

function Overlay:getMem()
	-- print("Overlay:getMem");
    return self.mem;
end

function Overlay:setMem(mem)
	print("Overlay:setMem", mem);
	if(self.mem ~= nil) then
		free_mem(self.mem);
	end

	self.mem = mem;
end

function Overlay:getSrc()
	-- print("Overlay:getSrc");
	return self.overlay.src;
end

function Overlay:setSrc(ov_src)
	print("Overlay:setSrc", ov_src);
	self.overlay.src = ov_src;
	self.ov_handle.ov = self.overlay;
end

function Overlay:getIs_fg()
	-- print("Overlay:getIs_fg");
	return self.overlay.is_fg;
end

function Overlay:setIs_fg(is_fg)
	print("Overlay:setIs_fg");
	self.overlay.is_fg = is_fg;
	self.ov_handle.ov = self.overlay;
end

function Overlay:getSrcRect()
	-- print("Overlay:getSrcRect");
	return self.overlay.src_rect;
end

function Overlay:setSrcRect(ov_src_rect)
	-- print("Overlay:setSrcRect");
	self.overlay.src_rect = ov_src_rect;
	self.ov_handle.ov = self.overlay;
end

function Overlay:getDstRect()
	-- print("Overlay:getDstRect");
	return self.overlay.dst_rect;
end

function Overlay:setDstRect(ov_dst_rect)
	print("Overlay:setDstRect");
	self.overlay.dst_rect = ov_dst_rect;
	self.ov_handle.ov = self.overlay;
end

function Overlay:setDstRectPosition(x, y)
	print("Overlay:setDstRectPosition (x,y)", x, y);
	self.dst_x = x;
	self.dst_y = y;

	local ov_dst_rect = self.overlay.dst_rect;
	ov_dst_rect.x = x;
	ov_dst_rect.y = y;
	self.overlay.dst_rect = ov_dst_rect;
	self.ov_handle.ov = self.overlay;
end

function Overlay:getDstRectPosition()
	-- print("Overlay:getDstRectPosition (x,y)",self.dst_x, ",", self.dst_y);
    return self.dst_x, self.dst_y;
end

function Overlay:setSrcRectPosition(x, y)
	print("Overlay:setSrcRectPosition (x,y)", x, y);
	self.src_x = x;
	self.src_y = y;

	local ov_src_rect = self.overlay.src_rect;
	ov_src_rect.x = x;
	ov_src_rect.y = y;
	self.overlay.src_rect = ov_src_rect;
	self.ov_handle.ov = self.overlay;
end

function Overlay:getSrcRectPosition()
	-- print("Overlay:getSrcRectPosition");
    return self.overlay.src_rect.x, self.overlay.src_rect.y;
end

function Overlay:setCrop(x, y, width, height)
	print("Overlay:setCrop (x,y,w,h)",x, y, width, height);
	self.x = x;
	self.y = y;

	local ov_src_rect = self.overlay.src_rect
	ov_src_rect.x = x;
	ov_src_rect.y = y;
	ov_src_rect.w = width;
	ov_src_rect.h = height;
	self.overlay.src_rect = ov_src_rect;

	local ov_dst_rect = self.overlay.dst_rect;
	ov_dst_rect.x = x;
	ov_dst_rect.y = y;
	ov_dst_rect.w = width;
	ov_dst_rect.h = height;
	self.overlay.dst_rect = ov_dst_rect;

	self.ov_handle.ov = self.overlay;
end

function Overlay:setDstRectWidth(width)
	print("Overlay:setDstRectWidth", width);
	local ov_dst_rect = self.overlay.dst_rect;
	ov_dst_rect.w = width;
	self.overlay.dst_rect = ov_dst_rect;
	self.ov_handle.ov = self.overlay;
end

function Overlay:setDstRectHeight(height)
	print("Overlay:setDstRectHeight", height);
	local ov_dst_rect = self.overlay.dst_rect;
	ov_dst_rect.h = height;
	self.overlay.dst_rect = ov_dst_rect;
	self.ov_handle.ov = self.overlay;
end

function Overlay:getDstRectWidth()
	-- print("Overlay:getDstRectWidth", self.overlay.dst_rect.w);
	return self.overlay.dst_rect.w;
end

function Overlay:getDstRectHeight()
	-- print("Overlay:getDstRectHeight", self.overlay.dst_rect.h);
	return self.overlay.dst_rect.h;
end

function Overlay:setSrcRectWidth(width)
	print("Overlay:setSrcRectWidth", width);
	local ov_src_rect = self.overlay.src_rect;
	ov_src_rect.w = width;
	self.overlay.src_rect = ov_src_rect;
	self.ov_handle.ov = self.overlay;
end

function Overlay:setSrcRectHeight(height)
	print("Overlay:setSrcRectHeight", height);
	local ov_src_rect = self.overlay.src_rect;
	ov_src_rect.h = height;
	self.overlay.src_rect = ov_src_rect;
	self.ov_handle.ov = self.overlay;
end

function Overlay:getSrcRectWidth()
	-- print("Overlay:getSrcRectWidth", self.overlay.src_rect.w);
	return self.overlay.src_rect.w;
end

function Overlay:getSrcRectHeight()
	-- print("Overlay:getSrcRectHeight", self.overlay.src_rect.h);
	return self.overlay.src_rect.h;
end

-- set format, can handle string input
function Overlay:setFormat(format)
	if(type(tonumber(format)) ~= "number") then
		format = string.upper(format);
		format = format_table[format];
	end

	print("Overlay:setFormat ",format);
	local ov_src = self.overlay.src;
	ov_src.format = format;
	self.overlay.src = ov_src;
	self.format = format;
	if (MDP_REV <= MDP3_REV) then
		local ov_req_src = self.req.src;
		ov_req_src.format = self.format;
		self.req.src = ov_req_src;
	end
	self.ov_handle.ov = self.overlay;
end

function Overlay:getFormat()
	-- print("Overlay:getFormat");
	return self.overlay.src.format;
end

-- Set overlay.src.width
function Overlay:setWidth(width)
	print("Overlay:setWidth",width);
	local ov_src = self.overlay.src;
	ov_src.width = width;
	self.overlay.src = ov_src;
	self.width = width;
	self.ov_handle.ov = self.overlay;
	if (MDP_REV <= MDP3_REV) then
		print("Overlay:setBlit Src Width", width);
		local ov_req_src = self.req.src;
		ov_req_src.width = width;
		self.req.src = ov_req_src;
	end
end

-- Set overlay.src.height
function Overlay:setHeight(height)
	print("Overlay:setHeight",height);
	local ov_src = self.overlay.src;
	ov_src.height = height;
	self.overlay.src = ov_src;
	self.height = height;
	self.ov_handle.ov = self.overlay;
	if (MDP_REV <= MDP3_REV) then
		print("Overlay:setBlit Src Height", height);
		local ov_req_src = self.req.src;
		ov_req_src.height = height;
		self.req.src = ov_req_src;
	end
end

-- Get overlay.src.width
function Overlay:getWidth()
	-- print("Overlay:getWidth",self.overlay.src.width);
	return self.overlay.src.width;
end

-- get overlay.src.height
function Overlay:getHeight()
	-- print("Overlay:getHeight",self.overlay.src.height);
	return self.overlay.src.height;
end

function Overlay:setZ_order(z_order)
	print("Overlay:setZ_order",z_order);
	self.z_order = z_order;
	self.overlay.z_order = z_order;
	self.ov_handle.ov = self.overlay;
end

function Overlay:getZ_order()
	-- print("Overlay:getZ_order");
	return self.overlay.z_order;
end

function Overlay:setAlpha(alpha)
	print("Overlay:setAlpha", alpha);
	self.alpha = alpha;
	self.overlay.alpha = alpha;
	self.ov_handle.ov = self.overlay;
end

function Overlay:getAlpha()
	-- print("Overlay:getAlpha");
	return self.overlay.alpha;
end

function Overlay:setFlags(flags)
	print("Overlay:setFlags", flags);
	local flags = flags;
	if(type(tonumber(flags)) ~= "number") then
		flags = string.upper(flags);
		flags = flags_table[flags];
	end
	print("Overlay:setFlags", flags);
	self.flags = flags;
	self.overlay.flags = flags;
	self.ov_handle.ov = self.overlay;
end

function Overlay:getFlags()
	-- print("Overlay:getFlags");
	return self.overlay.flags;
end

function Overlay:setId(id)
	print("Overlay:setId",id);
	self.id = id;
	self.overlay.id = id;
	self.ov_handle.ov = self.overlay;
end

function Overlay:getId()
	-- print("Overlay:getId");
    return self.overlay.id;
end

function Overlay:setTransp_mask(transp_mask)
	print("Overlay:setTransp_mask",transp_mask);
	self.transp_mask = transp_mask;
	self.overlay.transp_mask = transp_mask;
	self.ov_handle.ov = self.overlay;
end

function Overlay:getTransp_mask()
	-- print("Overlay:getTransp_mask");
	return self.overlay.transp_mask;
end

function Overlay:getData()
	-- print("Overlay:getData");
	return self.data;
end

function Overlay:setData(data)
	-- print("Overlay:setData");
	self.data = data;
	self.ov_handle.ov = self.overlay;
end

-- Clear the overlay, free memory, detach object, and destroy overlay_handle
function Overlay:clear()
	print("Overlay:clear");
	if(self.mem ~= nil) then
		free_mem(self.mem);
	end
	if (MDP_REV <= MDP3_REV) then
	if(self.mem_dest ~= nil) then
		free_mem(self.mem_dest);
	end
	end
	fb:detachObject(self);

	destroy_overlay_handle(self.ov_handle, self.fb.fb_handle);
end

-- Call fb:setOverlay
function Overlay:setOverlay()
	print("Overlay:setOverlay");
	if(self.show == false) then
		return 0;
	end
	print("Overlay:setOverlay", self.ov_type);
	local result = 0;
	if (MDP_REV <= MDP3_REV) then
		print("Blit ", SYNC_BLIT);
		if(self:blit(SYNC_BLIT) ~= 0) then
			print("Blit  failed");
			return -1;
		end
		print("Overlay:setOverlay", "Ov Fmt", self:getFormat(), "Req Dest Fmt", self.req.dst.format);
                self:setFormat(self.req.dst.format);
                self:setWidth(self.req.dst.width);
                self:setHeight(self.req.dst.height);
	print("Overlay:setOverlay", "Ov Fmt", self:getFormat(), "Req Dest Fmt", self.req.dst.format);
	end
	result = self.fb:setOverlay(self.overlay);
	self.ov_handle.ov = self.overlay;
	self:attachOverlay();
	return result;
end

-- call attach_overlay
function Overlay:attachOverlay()
	print("Overlay:attachOverlay");
	if (self.show == false) then
		return 0;
	end
	local result = attach_overlay(self.ov_handle);
	return result;
end

-- call detach_overlay
function Overlay:detachOverlay()
	print("Overlay:detachOverlay");
	local result = detach_overlay(self.ov_handle);
	return result;
end

--call fb:prepareAllOverlay
function Overlay:prepareAllOverlay(fb)
       print("Overlay:prepareAllOverlay");
       local result = self.fb:prepareAllOverlay();
       return result;
end
-- Call fb:getOverlay
function Overlay:getOverlay()
	-- print("Overlay:getOverlay");
	local result = self.fb:getOverlay(self.overlay);
	self.ov_handle.ov = self.overlay;
	return result;
end

-- Call fb:unsetOverlay
function Overlay:unsetOverlay()
	-- print("Overlay:unsetOverlay");
	if(self.show == false) then
		return 0;
	end
	local result = self.fb:unsetOverlay(self.overlay);
	self.ov_handle.ov = self.overlay;
	if (MDP_REV <= MDP3_REV) then
		local ov_data_data = self.data_blit.data;
		local ov_req_dst = self.req.dst;
		ov_data_data.offset = 0;
		ov_req_dst.offset = 0;
		print("Overlay:unsetOverlay -> mem_clear");

		mem_clear(self.mem_dest, 0, self.mem_dest.size, 0);
                BLT_BUFF_SWAP = 0;
	end
	self:detachOverlay();
	return result;
end

-- Call fb:playOverlay
function Overlay:playOverlay()
	print("Overlay:playOverlay");
	if(self.show == false) then
		return 0;
	end
	local result = 0;
	if (MDP_REV <= MDP3_REV) then
		print("Overlay:playOverlay(data_blit) MDP_REV", MDP_REV, "Mem ID ", self.data_blit.data.memory_id, "",self.data_blit.data.offset);
		result = self.fb:playOverlay(self.overlay, self.data_blit);
	else
		print("Overlay:playOverlay(data)", MDP_REV);
		result = self.fb:playOverlay(self.overlay, self.data);
	end

	self.ov_handle.ov = self.overlay;
	return result;
end

function Overlay:getSource()
	-- print("Overlay:getSource");
    return self.src;
end

function Overlay:hideOverlay()
	print("Overlay:hideOverlay");
	local result = self:unsetOverlay();

	if(result ~=0) then
		return result;
	end

	self.show = false;

	return 0;
end

function Overlay:showOverlay()
	print("Overlay:showOverlay");
	self.show = true;

	return 0;
end

function Overlay:setScale(width, height)
	print("Overlay:setScale");
	self:setDstRectWidth(width);
	self:setDstRectHeight(height);
end

-- Set overlay.horz_deci
function Overlay:setHorzDeci(horz_deci)
	print("Overlay:setHorzDeci",horz_deci);
	self.overlay.horz_deci = horz_deci;
	self.ov_handle.ov = self.overlay;
end

-- Set overlay.vert_deci
function Overlay:setVertDeci(vert_deci)
	print("Overlay:setVertDeci",vert_deci);
	self.overlay.vert_deci = vert_deci;
	self.ov_handle.ov = self.overlay;
end

function Overlay:blit(blitType)
	print("Overlay:blit -> BlitType ", blitType);
	local clear = true;

	if(tonumber(self:getAlpha()) ~= 255) then
		clear = false;
		BLT_BUFF_SWAP = 0;
	end

	if (BLT_BUFF_SWAP == 3) then
		BLT_BUFF_SWAP = 0;
	end

	local ov_data_data = self.data_blit.data;
	local ov_req_dst = self.req.dst;

	if ((BLT_BUFF_SWAP == 0) and (clear == true)) then
	ov_data_data.offset = 0;
	ov_req_dst.offset = 0;
	mem_clear(self.mem_dest, 0, self.mem_dest.size/3, 0);
	end
	if (BLT_BUFF_SWAP == 1) then
	ov_data_data.offset = self.mem_dest.size/3;
	ov_req_dst.offset = self.mem_dest.size/3;
	mem_clear(self.mem_dest, 0, self.mem_dest.size/3, self.mem_dest.size/3);
	end
	if (BLT_BUFF_SWAP == 2) then
	ov_data_data.offset = (self.mem_dest.size/3) * 2;
	ov_req_dst.offset = (self.mem_dest.size/3) * 2;
	mem_clear(self.mem_dest, 0, self.mem_dest.size/3, (self.mem_dest.size/3) *2);
	end
	self.data_blit.data = ov_data_data;
	self.req.dst = ov_req_dst;

	local ov_src_rect = self.req.src_rect;
	ov_src_rect.x, ov_src_rect.y = self:getSrcRectPosition();
	ov_src_rect.w = self:getSrcRectWidth();
	ov_src_rect.h = self:getSrcRectHeight();
	self.req.src_rect = ov_src_rect;
	self.req.flags = self:getFlags();

	local ov_dst_rect = self.req.dst_rect;
	ov_dst_rect.x, ov_dst_rect.y = self:getDstRectPosition();
	local dst_w = self:getDstRectWidth();
	local dst_h = self:getDstRectHeight();
	if(bit32.band(self.req.flags, MDP_ROT_90) ~= 0 or bit32.band(self.req.flags, MDP_ROT_270) ~= 0) then
		ov_dst_rect.h = math.min(self.req.dst.height, dst_w);
		ov_dst_rect.w = math.min(self.req.dst.width, dst_h);
	else
		ov_dst_rect.w = self:getDstRectWidth();
		ov_dst_rect.h = self:getDstRectHeight();
	end
	self.req.dst_rect = ov_dst_rect;
	self.req.alpha = self:getAlpha();
	self.req.transp_mask = self:getTransp_mask();

	print("Blit DST W ", ov_dst_rect.w, "H", ov_dst_rect.h, "OV W", self:getDstRectWidth(), "H ", self:getDstRectHeight(), "Flag",self.req.flags,
	"Transp Mask",self.req.transp_mask, "Alpha", self.req.alpha);

	local result = self.fb:blit(blitType, self.req);
	BLT_BUFF_SWAP = BLT_BUFF_SWAP + 1;
	return result;
end

----------
-- setPaParam: Wrapper function for SSPP PA configuration using MSMFB_OVERLAY_SET IOCTL
-- Inputs:
--      enable : (PA Enable --> true / PA Disable --> false)
--      globalPadata : (display_pp_pa_cfg)
-- 		hue        - Hue, valid from -180.0 to 180.0 degrees
-- 		intensity  - Intensity, valid from 0 to 255
-- 		sat_thresh - threshold for saturation, valid from 0 - 255
-- 		sat        - Saturation, valid from -1.0 to 1.0 (percentage)
-- 		contrast   - Contrast, valid from -1.0 to 1.0 (percentage)

function Overlay:setPaParam (enable, globalPadata)
	local pa_data = display_pp_pa_cfg();
	local result = 0;
	if(enable == true) then
		pa_data.ops = bit32.bor(MDP_PP_OPS_ENABLE, MDP_PP_OPS_WRITE);
	else
		pa_data.ops = bit32.bor(MDP_PP_OPS_DISABLE, MDP_PP_OPS_WRITE);
	end
	pa_data.hue = globalPadata.hue;
	pa_data.sat = globalPadata.sat;
	pa_data.sat_thresh = globalPadata.sat_thresh;
	pa_data.intensity = globalPadata.intensity;
	pa_data.contrast = globalPadata.contrast;
	print("Overlay:setPaParam pa_data.ops", pa_data.ops, "OV Id",self.overlay.id);
	result = self.fb:setOverlayPaParam(self.overlay, pa_data);
	self.ov_handle.ov = self.overlay;
	return result;
end

-- setCscParam: Wrapper function for VIG Pipe CSC configuration using MSMFB_OVERLAY_SET IOCTL
-- Inputs:
--      enable : (CSC Enable --> true / CSC Disable --> false)
--      cscMv : (3x3 Matrix of Color Space conversion coefficients in S4.9 format)
-- 		cscPreBv : 1x3 pre-bias value
-- 		cscPostBv : 1x3 post-bias value
-- 		cscPreLv :  3 pair of (Low,High) pre-clamp value
-- 		cscPostLv : 3 pair of (Low,High) post-clamp value
function Overlay:setCscParam (enable, cscMv, cscPreBv, cscPostBv, cscPreLv, cscPostLv)
	local csc_cfg = mdp_csc_cfg();
	local ops = 0;
	local result = 0;

	if(enable == true) then
		ops = MDP_PP_OPS_ENABLE;
	else
		ops = MDP_PP_OPS_DISABLE;
	end
	ops = bit32.bor(ops, MDP_PP_OPS_WRITE);

	csc_cfg.flags = ops;
	if(cscMv ~= nil) then
		for indx = 1, 9 , 1 do
		csc_cfg.csc_mv[indx] = cscMv[indx];
		end
	end
	if(cscPreBv ~= nil) then
		for indx = 1, 3 , 1 do
		csc_cfg.csc_pre_bv[indx] = cscPreBv[indx];
		end
	end
	if(cscPostBv ~= nil) then
		for indx = 1, 3 , 1 do
		csc_cfg.csc_post_bv[indx] = cscPostBv[indx];
		end
	end
	if(cscPreLv ~= nil) then
		for indx = 1, 6 , 1 do
		csc_cfg.csc_pre_lv[indx] = cscPreLv[indx];
		end
	end
	if(cscPostLv ~= nil) then
		for indx = 1, 6 , 1 do
		csc_cfg.csc_post_lv[indx] = cscPostLv[indx];
		end
	end
	print("Overlay:setCscParam csc_cfg.flags", csc_cfg.flags, "OV Id",self.overlay.id);
	result = self.fb:setOverlayCscParam(self.overlay, csc_cfg);
	return result;
end

-- setIgcParam: Wrapper function for SSPP IGC Lut configuration using MSMFB_OVERLAY_SET IOCTL
-- Inputs:
--      enable: (IGC Enable --> true / IGC Disable --> false)
--      rVal: (Table of size 256 For Red)
--      gVal: (Table of size 256 For Green)
--      bVal: (Table of size 256 For Blue)
function Overlay:setIgcParam (enable, rVal, gVal, bVal)
	local igcLut = display_pp_igc_lut_data();
	local ops = 0;
	if(enable == true) then
		ops = MDP_PP_OPS_ENABLE;
	else
		ops = MDP_PP_OPS_DISABLE;
	end
	ops = bit32.bor(ops, MDP_PP_OPS_WRITE);

	local indx = 1;
	for indx = 1, MAX_IGC_LUT_ENTRIES, 1 do
		igcLut.c0[indx] = rVal[indx];
		igcLut.c1[indx] = gVal[indx];
		igcLut.c2[indx] = bVal[indx];
	end

	igcLut.ops = ops;
	print("igcLut.ops ", igcLut.ops);
	return self.fb:setOverlayIgcParam(self.overlay, igcLut);
end

-- setQseedParam: Wrapper function for SSPP QSEED configuration using MSMFB_OVERLAY_SET IOCTL
-- Inputs:
--      enable: (QSEED Enable --> true / QSEED Disable --> false)
--      data: (display_pp_qseed_input_params->strength)
function Overlay:setQseedParam (enable, data)
	local qseed_cfg = mdp_qseed_cfg();
	local ops = 0;
	if(enable == true) then
		ops = MDP_PP_OPS_ENABLE;
	else
		ops = MDP_PP_OPS_DISABLE;
	end
	ops = bit32.bor(ops, MDP_PP_OPS_WRITE);

	print("qseed_cfg.ops ", ops);
	return self.fb:setOverlayQseedParam(self.overlay, ops, data);
end

-- struct display_pp_sharp_cfg - Structure for SEED2 sharpening
-- Inputs:
--      ops: Options for QSEED2 sharpening
--      edgeThr: Unsigned Threshold to select Edge/Normal Filter
--              for Content Adaptive Filter
--      smoothThr: Unsigned Threshold to select Normal/Smooth Filter
--              for Content Adaptive Filter
--      noiseThr: Unsigned Threshold to select Normal/Smooth Filter
--              for Content Adaptive Filter
--      strength: defines Filter operation mode
--              strength > 0 (sharpening Filter),
--              strength < 0 (smooth Filter)

function Overlay:setSharpParam (enable, edgeThr, smoothThr, noiseThr, strength)
	local sharp_cfg = display_pp_sharp_cfg();
	local ops = 0;
	if(enable == true) then
		ops = MDP_PP_OPS_ENABLE;
	else
		ops = MDP_PP_OPS_DISABLE;
	end
	ops = bit32.bor(ops, MDP_PP_OPS_WRITE);

	sharp_cfg.ops = ops;
	sharp_cfg.edge_thr = edgeThr;
	sharp_cfg.smooth_thr = smoothThr;
	sharp_cfg.noise_thr = noiseThr;
	sharp_cfg.strength = strength;

	print("qseed_cfg.ops ", sharp_cfg.ops);
	return self.fb:setOverlaySharpParam(self.overlay, sharp_cfg);
end

-- Reset path to image source, rest format, width, height, memory, framesize if needed
function Overlay:setSource(src, format, width, height)
	print("Overlay:setSource",src, format, width, height);
	local format = format or self:getFormat();
	local width = width or self:getWidth();
	local height = height or self:getHeight();

	local framesize = get_frame_size(self.format, self.width, self.height);

	if(framesize < get_frame_size(self.format, self.height, self.width)) then
		framesize = get_frame_size(self.format, self.height, self.width);
	end

	self.framesize = framesize;

	if (framesize <= 0) then
		print("Framesize not valid.");
		return nil;
	end

	self.framesize = framesize;

	if(format ~= self:getFormat()) then
		self:setFormat(format);
	end

	if(width ~= self:getWidth()) then
		self:setWidth(width);
		self:setSrcRectWidth(width);
		self:setDstRectWidth(width);
	end

	if(height ~= self:getHeight()) then
		self:setHeight(height);
		self:setSrcRectHeight(height);
		self:setDstRectHeight(height);
	end

	if(self.mem ~= nil) then
		free_mem(self.mem);
		self.mem = nil;
	end

	self.src = src;

	print("Overlay:setSource:alloc_mem <mem> ", self.framesize);
	self.mem = alloc_mem(self.framesize);

	if(read_file(self.mem, self.src, self.framesize, 0) <= 0) then
		print("File Read : ", self.src, " : FAILED");
	        return -1;
	end

	self.data = msmfb_overlay_data();

	local ov_data_data = self.data.data;
	ov_data_data.memory_id = self.mem.mem_fd;
	ov_data_data.offset = 0;
	ov_data_data.flags = 0;
	self.data.data = ov_data_data;

	self.ov_handle.ov = self.overlay;
end

-- Class for VideoOverlay, inherits from Overlay
VideoOverlay = Overlay:new();

-- Create a new VideoOverlay, create a mem_back to do avoid tearing
function VideoOverlay:new(obj, fb)
    -- print("VideoOverlay:new");
	if(obj == nil) then
		local obj = {};
		setmetatable(obj, self);
		self.__index = self;
		return obj;
	end

	local obj = Overlay:new(obj, fb);
	setmetatable(obj, self);
	self.__index = self;
	obj.vinfo = fb:getFbVarScreenInfo();
	if(obj == nil) then
		return nil;
	end

	if(obj.src ~= nil) then
		local file = io.open(obj.src, "r");
        if (file == nil) then
        print(obj.src);
        error("File Open failed\n");
        end
		local filesize = file:seek("end");
		obj.frames = filesize / obj.framesize;

		print("VideoOverlay:new:alloc_mem <mem_back> ", obj.framesize);
        obj.mem_back = alloc_mem(obj.framesize);

		obj.cur_frame = 0;
	end

	return obj;
end

-- Get both mem and mem_back
function VideoOverlay:getMem()
    -- print("VideoOverlay:getMem");
	return self.mem, self.mem_back;
end

-- Set both mem and mem_back
function VideoOverlay:setMem(mem, mem_back)
	-- print("VideoOverlay:setMem");
    if(self.mem ~= nil) then
		free_mem(self.mem);
	end

	if(self.mem_back ~= nil) then
		free_mem(self.mem_back);
	end

	self.mem = mem;
	self.mem_back = mem_back;
end

-- VideoOverlay playOverlay, and it only push data for one frame at a time
function VideoOverlay:playOverlay()
	print("VideoOverlay:playOverlay");
	if(self.show == false) then
	    return 0;
        end

	local result = self.fb:playOverlay(self.overlay, self.data);

	local next_mem = nil;

	if(self.mem_back == nil and self.mem == nil) then
		return 0;
	end

	if(self.cur_frame % 2 ==0) then
		next_mem = self.mem_back;
	else
		next_mem = self.mem;
	end

	self.cur_frame = self.cur_frame + 1;

	if(self.cur_frame == self.frames) then
		return -1;
	end
	-- print("VP DEBUG " ,self.src, self.framesize, self.cur_frame);
	if(read_file(next_mem, self.src, self.framesize, self.framesize * self.cur_frame) <= 0) then
		print("File Read : ", self.src, " : FAILED");
		return -1;
	end

	local ov_data_data = self.data.data;
	ov_data_data.memory_id = next_mem.mem_fd;
	ov_data_data.offset = 0;
	ov_data_data.flags = 0;
	self.data.data = ov_data_data;

	self.ov_handle.ov = self.overlay;

	return result;
end

-- free mem and mem_back, detach object, and destroy overlay_handle.
function VideoOverlay:clear()
    -- print("VideoOverlay:clear");
	if(self.mem ~= nil) then
		free_mem(self.mem);
	end

	if(self.mem_back ~= nil) then
		free_mem(self.mem_back);
	end

	fb:detachObject(self);

	destroy_overlay_handle(self.ov_handle, self.fb.fb_handle);
end

-- Reset path to image source, rest format, width, height, memory, framesize if needed
function VideoOverlay:setSource(src, format, width, height)
	print("VideoOverlay:setSource",src, format, width, height);
    local format = format or self:getFormat();
	local width = width or self:getWidth();
	local height = height or self:getHeight();

	local framesize = get_frame_size(self.format, self.width, self.height);

	if(framesize < get_frame_size(self.format, self.height, self.width)) then
		framesize = get_frame_size(self.format, self.height, self.width);
	end

	if (framesize <= 0) then
		print("Framesize not valid.");
		return nil;
	end

	self.framesize = framesize;

	if(format ~= self:getFormat()) then
		self:setFormat(format);
	end

	if(width ~= self:getWidth()) then
		self:setWidth(width);
	end

	if(height ~= self:getHeight()) then
		self:setHeight(height);
	end

	if(self.mem ~= nil) then
		free_mem(self.mem);
		self.mem = nil;
	end

	if(self.mem_back ~= nil) then
		free_mem(self.mem_back);
		self.mem_back = nil;
	end

	self.src = src;

	print("VideoOverlay:setSource:alloc_mem <mem>", framesize);
	self.mem = alloc_mem(framesize);

	if(read_file(self.mem, self.src, framesize, 0) <= 0) then
		print("File Read : ", self.src, " : FAILED");
		return -1;
	end

	self.data = msmfb_overlay_data();

	local ov_data_data = self.data.data;
	ov_data_data.memory_id = self.mem.mem_fd;
	ov_data_data.offset = 0;
	ov_data_data.flags = 0;
	self.data.data = ov_data_data;

	local file = io.open(self.src, "r");
	local filesize = file:seek("end");

	self.frames = filesize / self.framesize;

	print("VideoOverlay:setSource:alloc_mem <mem_back>", self.framesize);
	self.mem_back = alloc_mem(self.framesize);

	self.cur_frame = 0;

	self.ov_handle.ov = self.overlay;
end

-- VideoOverlay to String
function VideoOverlay:toString()
	local result = "{";
	result = result .. string.format("%s = \"%s\",", "type", "video");
	result = result .. string.format("%s = \"%s\",", "source", tostring(self.src));
	--result = result .. string.format("%s = \"%s\",", "framesize", tostring(self.framesize));
	result = result .. string.format("%s = \"%s\",", "frames", tostring(self.frames));
	result = result .. string.format("%s = \"%s\" ", "cur_frame", tostring(self.cur_frame));
	result = result .. mdp_overlay_to_string(self.overlay);
	return result .. "}";
end

-- Class for RotOverlay, inherits from Overlay
RotOverlay = Overlay:new();

-- Create a new RotOverlay, also initialize mem_dst for rotated data
function RotOverlay:new(obj, fb)
	-- print("RotOverlay:new");
	if(obj == nil) then
		local obj = {};
		setmetatable(obj, self);
		self.__index = self;
		return obj;
	end

	local obj = Overlay:new(obj, fb);
    local format = obj:getFormat()
	setmetatable(obj, self);
	self.__index = self;
	if(obj == nil) then
		return nil;
	end
    obj.rotation = obj.rotation or MDP_ROT_NOP;
-- Update Rotate Destination format
    local fixinfo = fb:getFbFixScreenInfo();
    local rotDstFormat = obj:getDestFormat(obj.rotation, format);
    local rotDstSize = get_frame_size(rotDstFormat, obj:getWidth(),  obj:getHeight());

    print("RotOverlay:new:alloc_mem <mem_dest> ", (obj.framesize + rotDstSize) , "obj.framesize", obj.framesize) ;
    obj.mem_dst = alloc_mem(obj.framesize + rotDstSize);

	if(obj.rotation ~= MDP_ROT_NOP or obj.rotation ~= MDP_ROT_90 or obj.rotation ~= MDP_ROT_180 or obj.rotation ~= MDP_ROT_270) then
		obj.rotation = rotation_table[obj.rotation];
	end

	if (obj.rotation ~= nil) then
		obj.overlay.flags = bit32.bor(obj.overlay.flags, obj.rotation);
	end

	obj:setDstRectWidth(obj:getHeight());
	obj:setDstRectHeight(obj:getWidth());
	obj.ov_handle.ov = obj.overlay;

	return obj;
end

-- Call fb:performRotate, also switch mem and mem_dst
function RotOverlay:performRotate(fb)
    print("RotOverlay:performRotate");
	self.overlay.flags = bit32.bor(self.overlay.flags, MDSS_MDP_ROT_ONLY);

	self.flags = self.overlay.flags;
	local ov_dst = msmfb_data();
	ov_dst.offset = 0;
	ov_dst.flags = 0;
	ov_dst.memory_id = self.mem_dst.mem_fd;

	if(self.fb:performRotate(self.overlay, self.data.data, ov_dst) ~= 0) then
		return -1;
	end

	self.data.data = ov_dst;

	if(bit32.band(self.overlay.flags, MDP_ROT_90) ~= 0 or bit32.band(self.overlay.flags, MDP_ROT_270) ~= 0) then
        print("RotOverlay:performRotate === Update HxW for 90/270");
		local temp_width = self:getHeight();
		local temp_height = self:getWidth();

		self:setWidth(temp_width);
		self:setHeight(temp_height);
		self:setSrcRectWidth(temp_width);
		self:setSrcRectHeight(temp_height);
		self:setDstRectWidth(temp_width);
		self:setDstRectHeight(temp_height);
	end

	local temp_mem = self.mem;
	self.mem = self.mem_dst;
	self.mem_dst = temp_mem;

	self.ov_handle.ov = self.overlay;

	return 0;
end

-- setRotateScaleParam
function RotOverlay:setScale(width, height)
	print("RotOverlay:setScale (WxH)",width,"x",height);
	self:setDstRectWidth(width);
    self:setDstRectHeight(height);
end

-- checkDestFormat
function RotOverlay:getDestFormat(rotation, format)
    self:setFlags(MDP_ROT_NOP);
    local rotation  = rotation;
    if(rotation >  MDP_ROT_270) then
	rotation = rotation_table[rotation];
    end
    local rotDstFormat;

	if ((rotation - MDP_ROT_90) == 0 or (rotation - MDP_ROT_270) == 0) then
		if ((format - MDP_RGB_565) == 0 or
           (format - MDP_BGR_565) == 0 )then
            rotDstFormat = MDP_RGB_888
        elseif ((format - MDP_Y_CBCR_H2V2_VENUS) == 0 or
                (format - MDP_Y_CBCR_H2V2) == 0 or
                (format - MDP_Y_CB_CR_H2V2) == 0 or
                (format - MDP_Y_CR_CB_GH2V2) == 0 or
                (format - MDP_Y_CR_CB_H2V2) == 0 ) then
            rotDstFormat = MDP_Y_CRCB_H2V2;
        else
            rotDstFormat = format;
        end
    else
        if ((format - MDP_Y_CB_CR_H2V2) == 0 or
            (format - MDP_Y_CR_CB_GH2V2) == 0 or
            (format - MDP_Y_CR_CB_H2V2) == 0)  then
            rotDstFormat = MDP_Y_CRCB_H2V2;
        else
			rotDstFormat = format;
        end
    end
    print("RotOverlay:checkDestFormat Rot = ", self.rotation ,"Format ", format, "Out format ", rotDstFormat);
    return rotDstFormat;
end

function RotOverlay:getRotation()
    -- print("RotOverlay:getRotation");
	return self.rotation;
end

-- Set rotation, can handle string input
function RotOverlay:setRotation(rotation)
	print("RotOverlay:setRotation", rotation);
    self:setFlags(MDP_ROT_NOP);
    local rotation  = rotation;
	if(rotation ~= MDP_ROT_NOP or rotation ~= MDP_ROT_90 or rotation ~= MDP_ROT_180 or rotation ~= MDP_ROT_270) then
		rotation = rotation_table[rotation];
	end
	self.rotation = rotation;
	self:setFlags(bit32.bor(self:getFlags(), self.rotation));
end


-- Get mem and mem_dst
function RotOverlay:getMem()
	print("RotOverlay:getMem");
    return self.mem, self.mem_dst;
end

-- Get mem and mem_dst
function RotOverlay:swapMem()
	print("RotOverlay:swapMem");
	local temp_mem = self.mem;
	self.mem = self.mem_dst;
	self.mem_dst = temp_mem;
end

-- Set mem and mem_dst
function RotOverlay:setMem(mem, mem_dst)
	print("RotOverlay:setMem");
    if(self.mem ~= nil) then
		free_mem(self.mem);
	end

	if(self.mem_dst ~= nil) then
		free_mem(self.mem_dst);
	end

	self.mem = mem;
	self.mem_dst = mem_dst;
end

-- Clear RotOverlay, free mem and mem_dst. detach object and destroy overlay handle
function RotOverlay:clear()
	print("RotOverlay:clear");
    if(self.mem ~= nil) then
		free_mem(self.mem);
	end

	if(self.mem_dst ~= nil) then
		free_mem(self.mem_dst);
	end

	self.fb:detachObject(self);

	destroy_overlay_handle(self.ov_handle, self.fb.fb_handle);
end

-- Reset path to image source, rest format, width, height, memory, framesize if needed
function RotOverlay:setSource(src, format, width, height)
	print("RotOverlay:setSource");
    local format = format or self:getFormat();
	local width = width or self:getWidth();
	local height = height or self:getHeight();

	local framesize = get_frame_size(self.format, self.width, self.height);

	if(framesize < get_frame_size(self.format, self.height, self.width)) then
		framesize = get_frame_size(self.format, self.height, self.width);
	end

	if (framesize <= 0) then
		print("Framesize not valid.");
		return nil;
	end

	self.framesize = framesize;

	if(format ~= self:getFormat()) then
		self:setFormat(format);
	end

	if(width ~= self:getWidth()) then
		self:setWidth(width);
	end

	if(height ~= self:getHeight()) then
		self:setHeight(height);
	end

	if(self.mem ~= nil) then
		free_mem(self.mem);
		self.mem = nil;
	end

	if(self.mem_dst ~= nil) then
		free_mem(self.mem_dst);
		self.mem_back = nil;
	end

	self.src = src;
	print("RotOverlay:setSource:alloc_mem <mem>", framesize);
	self.mem = alloc_mem(framesize);

	read_file(self.mem, self.src, framesize, 0)

	self.data = msmfb_overlay_data();

	local ov_data_data = self.data.data;
	ov_data_data.memory_id = self.mem.mem_fd;
	ov_data_data.offset = 0;
	ov_data_data.flags = 0;
	self.data.data = ov_data_data;
	print("RotOverlay:setSource:alloc_mem <mem_dest> ", self.framesize);
	self.mem_dst = alloc_mem(self.framesize);

	self.ov_handle.ov = self.overlay;
end

-- RotOverlay to String
function RotOverlay:toString()
	local result = "{";
	result = result .. string.format("%s = \"%s\",", "type", "rotate");
	result = result .. string.format("%s = \"%s\" ", "source", tostring(self.src));
	--result = result .. string.format("%s = \"%s\",", "framesize", tostring(self.framesize));
	result = result .. mdp_overlay_to_string(self.overlay);
	return result .. "}";
end

-- A class create for handle split overlay.
-- It will create two Overlay object, and send each one of them to left mixer and right mixer.
-- SplitOverlay has been tested for test_format, test_move, test_rotate, test_scale, test_crop, test_blending, test_blending_pixel, test_multiop_brmcs.
-- However, it may be buggy in other split display scenario
SplitOverlay = AbstractOverlay:new();

function SplitOverlay:new(obj, fb)
	print("SplitOverlay:new");
	if(obj == nil) then
		local obj = {};
		setmetatable(obj, self);
		self.__index = self;
		return obj;
	end

	local obj1, obj2 = table.copy(obj), table.copy(obj);

	obj1.show = true;
	obj2.show = false;
	obj2.src = nil;

	local obj = AbstractOverlay:new(obj, fb);
	setmetatable(obj, self);
	self.__index = self;

	if(obj == nil) then
		return nil;
	end

	obj.vinfo = fb:getFbVarScreenInfo();

	obj.max_width = obj.vinfo.xres - fb:getRightMaxWidth();

	obj.left_ov = Overlay:new(obj1, fb);

	obj.right_ov = Overlay:new(obj2, fb);

	obj.right_ov:setData(obj.left_ov:getData());

	if(IS_SOURCE_SPLIT_SUPPORTED == false) then
		print("Set MDSS_MDP_RIGHT_MIXER Flag ", IS_SOURCE_SPLIT_SUPPORTED);
		obj.right_ov:setFlags(bit32.bor(obj.right_ov:getFlags(), MDSS_MDP_RIGHT_MIXER));
	else
		print("Donot MDSS_MDP_RIGHT_MIXER Flag ", IS_SOURCE_SPLIT_SUPPORTED);
	end

	if(obj.flip ~= nil) then
		obj.flags = bit32.bxor(obj:getFlags(), obj.flip);
	end

	obj:setDstRectPosition(obj.dst_x, obj.dst_y);
	IS_SPLIT_OVERLAY_USED = true;
	return obj;
end

function SplitOverlay:getLeftOv()
return self.left_ov;
end
function SplitOverlay:getRightOv()
return self.right_ov;
end

function SplitOverlay:setFormat(format)
	print("SplitOverlay:setFormat");
    self.left_ov:setFormat(format);
	self.right_ov:setFormat(format);
end

function SplitOverlay:getData()
	-- print("SplitOverlay:getData");
    return self.left_ov:getData();
end

function SplitOverlay:setData(data)
	-- print("SplitOverlay:setData");
    self.left_ov:setData(data);
	self.right_ov:setData(data);
end

-- Set overlay.horz_deci
function SplitOverlay:setHorzDeci(horz_deci)
	print("SplitOverlay:setHorzDeci",horz_deci);
	self.left_ov:setHorzDeci(horz_deci);
	self.right_ov:setHorzDeci(horz_deci);
end

-- Set overlay.vert_deci
function SplitOverlay:setVertDeci(vert_deci)
	print("SplitOverlay:setVertDeci",vert_deci);
	self.left_ov:setVertDeci(vert_deci);
	self.right_ov:setVertDeci(vert_deci);
end

function SplitOverlay:setSrcRectPosition(x, y)
	print("SplitOverlay:setSrcRectPosition (x,y)",x,y);
    local src_x = x;
	local src_y = y;

	local dst_x, dst_y = self:getDstRectPosition();

	-- If the overlay's src is in the left part of screen
	-- We just display the left overlay
	if(src_x + self:getSrcRectWidth() < self.max_width) then
		self.right_ov:hideOverlay();
		self.left_ov:showOverlay();

		self.left_ov:setSrcRectPosition(src_x, src_y);
	elseif(src_x < self.max_width) then
		-- if it is right in the middle
		self.right_ov:showOverlay();
		self.left_ov:showOverlay();

		local left_src_x = src_x;
		local right_src_x = src_x + self:getSrcRectWidth() - self.max_width;

		-- If horizontal flip happen, change src_x of both overlay
		if(bit32.band(self:getFlags(), MDP_FLIP_LR) ~= 0) then
			left_src_x = self:getWidth() - right_src_x;
			right_src_x = 0;
		end

		self.left_ov:setSrcRectPosition(left_src_x, src_y);
		self.right_ov:setSrcRectPosition(right_src_x, src_y);
	else
	-- If in right mixer, only use right overlay
		self.right_ov:showOverlay();
		self.left_ov:hideOverlay();

		self.right_ov:setSrcRectPosition(src_x - self.max_width, src_y);
	end

	self.src_x = x;
	self.src_y = y;
	return 0;
end

function SplitOverlay:setDstRectPosition(dst_x, dst_y)
    print("SplitOverlay:setDstRectPosition (x,y)",dst_x,",",dst_y);
	local dst_x = dst_x;
	local dst_y = dst_y;

	local src_x, src_y = self:getSrcRectPosition();

	if(dst_x + self:getDstRectWidth() > self.max_width) then
		if(dst_x >= self.max_width) then
			if(self.right_ov:getDstRectWidth() > self.max_width) then
				return -1;
			end
			-- If it is in the right mixer, only right overlay
			self.right_ov:showOverlay();
			self.left_ov:hideOverlay();

			if(IS_SOURCE_SPLIT_SUPPORTED == false) then
				self.right_ov:setDstRectPosition(dst_x - self.max_width, dst_y);
			else
				self.right_ov:setDstRectPosition(dst_x, dst_y);
			end
		else
			-- in the middle
			self.right_ov:showOverlay();
			self.left_ov:showOverlay();

			local left_width = self.max_width - dst_x;

			-- Caculate the scaling ratio of the image
			local scale_w = math.ceil (self:getDstRectWidth() / self:getSrcRectWidth());

			local right_src_x = math.ceil (src_x + left_width / scale_w);
			local right_src_w = self.right_ov:getWidth() - left_width / scale_w;
			local left_src_w = math.ceil (left_width / scale_w);

			local left_src_x, left_src_y = self.left_ov:getSrcRectPosition();

			-- If horizontal flip happen
			if(bit32.band(self:getFlags(), MDP_FLIP_LR) ~= 0) then
				left_src_x = self:getWidth() - right_src_x;
				right_src_x = 0;
			end

			-- yuv format overlay cannot have odd src rect coordinates
			if(is_yuv(self.format) == true) then
				right_src_x = round_down_to_even(right_src_x);
				right_src_w = round_up_to_even(right_src_w);
				left_src_w = round_up_to_even(left_src_w);
				left_src_x = round_down_to_even(left_src_x);
			end

			self.right_ov:setDstRectPosition(self.max_width, dst_y);
			self.right_ov:setSrcRectPosition(right_src_x, src_y);
			self.right_ov:setDstRectWidth(self.right_ov:getWidth() - left_width);
			self.right_ov:setSrcRectWidth(right_src_w);

			self.left_ov:setDstRectPosition(dst_x, dst_y);
			self.left_ov:setSrcRectPosition(left_src_x, left_src_y);
			self.left_ov:setDstRectWidth(left_width);
			self.left_ov:setSrcRectWidth(left_src_w);

		end
	else
		-- left mixer, only left overlay
		self.right_ov:hideOverlay();
		self.left_ov:showOverlay();

		local left_width = self.max_width - dst_x;
		if(self.left_ov:getSrcRectWidth() == self.max_width/2) then
		self.left_ov:setSrcRectWidth(left_src_w);
		end
		self.left_ov:setDstRectPosition(dst_x, dst_y);
	end

	self.dst_x = dst_x;
	self.dst_y = dst_y;

	return 0;
end

function SplitOverlay:setHeight(height)
    print("SplitOverlay:setHeight",height);
	self.height = height;
	self.left_ov:setHeight(height);
	self.right_ov:setHeight(height);
end

function SplitOverlay:setWidth(width)
	print("SplitOverlay:setWidth",width);
    self.width = width;
	self.left_ov:setWidth(width);
	self.right_ov:setWidth(width);
end

function SplitOverlay:setDstRectHeight(height)
	print("SplitOverlay:setDstRectHeight",height);
    self.dst_h = height;
	self.left_ov:setDstRectHeight(height);
	self.right_ov:setDstRectHeight(height);
end

function SplitOverlay:setScale(width, height)
	print("SplitOverlay:setScale (WxH)",width,"x",height);
    self:setDstRectHeight(height);
	self:setDstRectWidth(width);
end

function SplitOverlay:setDstRectWidth(width)
	print("SplitOverlay:setDstRectWidth",width);
    local dst_x, dst_y = self:getDstRectPosition();
	local src_x, src_y = self:getSrcRectPosition();
	if(dst_x + width <= self.max_width) then
		-- Only use left mixer
		self.right_ov:hideOverlay();
		self.left_ov:showOverlay();

		self.left_ov:setDstRectWidth(width);
	elseif(dst_x < self.max_width) then
		-- Use both overlay
		-- Here, it is actually use scale ratio and dst width to get right overlay src_rect_w
		-- Finally use src_rect_w and scale ratio to get the dst_rect_w.
		local src_w = self:getSrcRectWidth();

		-- Caculate the scale ratio
		local scale_w = math.ceil (width / self:getSrcRectWidth());

		local right_width = width + dst_x - self.max_width;

		local right_src_w = math.ceil (right_width / scale_w);
		local right_src_x = src_x + src_w - right_src_w;
		local left_src_w = src_w - right_src_w;

		local left_src_x, left_src_y = self.left_ov:getSrcRectPosition();

		-- Horizontal flip happen
		if(bit32.band(self:getFlags(), MDP_FLIP_LR) ~= 0) then
			left_src_x = self:getWidth() - right_src_x;
			right_src_x = 0;
		end

		-- Yuv format cannot have odd src_rect coordinate
		if(is_yuv(self.format) == true) then
			right_src_x = round_down_to_even(right_src_x);
			right_src_w = round_up_to_even(right_src_w);
			left_src_w = round_up_to_even(left_src_w);
			left_src_x = round_down_to_even(left_src_x);
		end

		-- src_rect_width must be larger than 1
		if(right_src_w >= 1) then
			self.right_ov:setSrcRectPosition(right_src_x, src_y);
			self.right_ov:setDstRectWidth(right_width);
			self.right_ov:setSrcRectWidth(right_src_w);
			self.right_ov:setDstRectPosition(self.max_width, src_y);
			self.right_ov:showOverlay();

			self.left_ov:setDstRectWidth(self.max_width - dst_x);
			self.left_ov:setSrcRectPosition(left_src_x, left_src_y);
			self.left_ov:setSrcRectWidth(left_src_w);
			self.left_ov:showOverlay();
		end

	else
		self.right_ov:showOverlay();
		self.left_ov:hideOverlay();

		self.right_ov:setDstRectWidth(width);
	end

	self.dst_w = width;

	return 0;
end

function SplitOverlay:setSrcRectWidth(width)
	print("SplitOverlay:setSrcRectWidth",width);
	local dst_x, dst_y = self:getDstRectPosition();
	local src_x, src_y = self:getSrcRectPosition();

	if(src_x + width <= self.max_width) then
		-- Only use left overlay
		self.right_ov:hideOverlay();
		self.left_ov:showOverlay();

		self.left_ov:setSrcRectWidth(width);
		self.left_ov:setSrcRectPosition(src_x, src_y);
	elseif(src_x < self.max_width) then
		-- In the middle, use both
		self.right_ov:showOverlay();
		self.left_ov:showOverlay();

		local left_src_x, left_src_y = self.left_ov:getSrcRectPosition();
		local right_src_x = self.max_width;

		-- If horizontal flip happen
		if(bit32.band(self:getFlags(), MDP_FLIP_LR) ~= 0) then
			left_src_x = self:getWidth() - right_src_x;
			right_src_x = 0;
		end

		self.left_ov:setSrcRectWidth(self.max_width - src_x);
		self.right_ov:setSrcRectPosition(left_src_x, left_src_y);
		self.right_ov:setSrcRectPosition(right_src_x, src_y);
		self.right_ov:setSrcRectWidth(src_x + width - self.max_width);
	else
		self.right_ov:showOverlay();
		self.left_ov:hideOverlay();

		self.right_ov:setSrcRectWidth(width);
	end

	self.src_w = width;
	return 0;
end

function SplitOverlay:setSrcRectHeight(height)
	print("SplitOverlay:setSrcRectHeight",height);
	self.src_h = height;
	self.left_ov:setSrcRectHeight(height);
	self.right_ov:setSrcRectHeight(height);
end

function SplitOverlay:setFlags(flags)
	print("SplitOverlay:setFlags", flags);
	local flags = flags;
	if(type(tonumber(flags)) ~= "number") then
		flags = string.upper(flags);
		flags = flags_table[flags];
	end

	self.flags = flags;

	self.left_ov:setFlags(flags);
	if(IS_SOURCE_SPLIT_SUPPORTED == false) then
		-- The MDSS_MDP_RIGHT_MIXER must be kept to push right overlay to right mixer
		self.right_ov:setFlags(bit32.bor(flags, MDSS_MDP_RIGHT_MIXER));
	end
end

function SplitOverlay:setOverlay()
	print("SplitOverlay:setOverlay");
	local result = self.left_ov:setOverlay();

	if(result ~=0) then
		return result;
	end

	local result = self.right_ov:setOverlay();

	if(result ~=0) then
		return result;
	end

	return 0;
end

function SplitOverlay:playOverlay()
	print("SplitOverlay:playOverlay");
	local result = self.left_ov:playOverlay();

	if(result ~=0) then
		return result;
	end

	local result = self.right_ov:playOverlay();

	if(result ~=0) then
		return result;
	end

	return 0;
end

function SplitOverlay:unsetOverlay()
	print("SplitOverlay:unsetOverlay");
	print("SplitOverlay:unsetLeftOverlay Id ", self.left_ov:getId());
	local result = self.left_ov:unsetOverlay();
	print("SplitOverlay:unsetLeftOverlay Result ", result);
	if(result ~=0) then
		return result;
	end

	print("SplitOverlay:unsetRightOverlay ID", self.right_ov:getId() );
	local result = self.right_ov:unsetOverlay();
	print("SplitOverlay:unsetRightOverlay Result ", result);
	if(result ~=0) then
	    return result;
	end
	return 0;
end

function SplitOverlay:setAlpha(alpha)
	print("SplitOverlay:setAlpha", alpha);
	self.right_ov:setAlpha(alpha);
	self.left_ov:setAlpha(alpha);
	self.alpha = alpha;
end

function SplitOverlay:doTransform()
	-- Function for handle horizontal flip
	print("SplitOverlay:doTransform");
	if(bit32.band(self:getFlags(), MDP_FLIP_LR) ~= 0) then
		local left_src_x, left_src_y = self.left_ov:getSrcRectPosition();
		local right_src_x, right_src_y = self.right_ov:getSrcRectPosition();
		local left_src_w = self.left_ov:getSrcRectWidth();
		local right_src_w = self.right_ov:getSrcRectWidth();
		local dst_x, dst_y = self:getDstRectPosition();
		local dst_w = self:getDstRectWidth();

		if(dst_x + dst_w <= self.max_width) then
			self.left_ov:showOverlay();
			self.right_ov:hideOverlay();
		elseif(dst_x < self.max_width) then
			-- In the middle, switch the src_rect x.
			self.left_ov:showOverlay();
			self.right_ov:showOverlay();

			self.left_ov:setSrcRectPosition(self:getWidth() - right_src_x, left_src_y);
			self.right_ov:setSrcRectPosition(0, right_src_y);
		else
			self.left_ov:hideOverlay();
			self.right_ov:showOverlay();
		end
	end
end

function SplitOverlay:setFlip(flip)
	print("SplitOverlay:setFlip", flip);
	local flip = flip or 0;

	if(type(tonumber(flip)) ~= "number") then
		flip = string.upper(flip);
		flip = format_table[flip];
	end

	self.flip = flip;
	self:setFlags(bit32.bxor(self:getFlags(), self.flip));
	self:doTransform();
end

function SplitOverlay:clear()
	-- print("SplitOverlay:clear");
	self.right_ov:clear();
	self.right_ov = nil;

	self.left_ov:clear();
	self.left_ov = nil;

	fb:detachObject(self);
end

function SplitOverlay:setCrop(x, y, width, height)
	print("SplitOverlay:setCrop (x,y,w,h)",x, y, width, height);
	self:setDstRectPosition(x, y);
	self:setDstRectWidth(width);
	self:setDstRectHeight(height);

	self:setSrcRectPosition(x, y);
	self:setSrcRectWidth(width);
	self:setSrcRectHeight(height);
end

-- Set blend_op, can handle string input
function SplitOverlay:setBlend_op(blend_op)
	print("SplitOverlay:setBlend_op", blend_op);
	local blend_op = blend_op or 0;

	if(type(tonumber(blend_op)) ~= "number") then
		blend_op = string.upper(blend_op);
		blend_op = blend_op_table[blend_op];
	end

	self.blend_op = blend_op;
	self.left_ov:setBlend_op(blend_op);
	self.right_ov:setBlend_op(blend_op);
end

function SplitOverlay:setPaParam (enable, globalPadata)
	local result = -1;
	print("SplitOverlay:setPaParam LeftOv Id",self.left_ov.id,"RightOv Id",self.right_ov.id);
	result = self.left_ov:setPaParam(enable, globalPadata);
	if(result ~= 0) then
		print("SplitOverlay:setPaParam LeftOv Id", self.left_ov.id, ":FAILED");
		return result;
	end
	result = self.right_ov:setPaParam(enable, globalPadata);
	if(result ~= 0) then
		print("SplitOverlay:setPaParam RightOv Id", self.right_ov.id, ":FAILED");
		return result;
	end
	return result;
end

function SplitOverlay:setCscParam (enable, cscMv, cscPreBv, cscPostBv, cscPreLv, cscPostLv)
	local result = -1;
	print("SplitOverlay:setCscParam LeftOv Id",self.left_ov.id,"RightOv Id",self.right_ov.id);
	result = self.left_ov:setCscParam(enable, cscMv, cscPreBv, cscPostBv, cscPreLv, cscPostLv);
	if(result ~= 0) then
		print("SplitOverlay:setCscParam LeftOv Id", self.left_ov.id, ":FAILED");
		return result;
	end
	result = self.right_ov:setCscParam(enable, cscMv, cscPreBv, cscPostBv, cscPreLv, cscPostLv);
	if(result ~= 0) then
		print("SplitOverlay:setCscParam RightOv Id", self.right_ov.id, ":FAILED");
		return result;
	end

end

function SplitOverlay:setIgcParam (enable, rVal, gVal, bVal)
	local result = -1;
	print("SplitOverlay:setIgcParam LeftOv Id",self.left_ov.id,"RightOv Id",self.right_ov.id);
	result = self.left_ov:setIgcParam(enable, rVal, gVal, bVal);
	if(result ~= 0) then
		print("SplitOverlay:setIgcParam LeftOv Id", self.left_ov.id, ":FAILED");
		return result;
	end
	result = self.right_ov:setIgcParam(enable, rVal, gVal, bVal);
	if(result ~= 0) then
		print("SplitOverlay:setIgcParam RightOv Id", self.right_ov.id, ":FAILED");
		return result;
	end
	return result;
end

function SplitOverlay:setQseedParam (enable, data)
	local result = -1;
	print("SplitOverlay:setQseedParam LeftOv Id",self.left_ov.id,"RightOv Id",self.right_ov.id);
	result = self.left_ov:setQseedParam(enable, data);
	if(result ~= 0) then
		print("SplitOverlay:setQseedParam LeftOv Id", self.left_ov.id, ":FAILED");
		return result;
	end
	result = self.right_ov:setQseedParam(enable, data);
	if(result ~= 0) then
		print("SplitOverlay:setQseedParam RightOv Id", self.right_ov.id, ":FAILED");
		return result;
	end
	return result;
end

function SplitOverlay:setSharpParam (enable, edgeThr, smoothThr, noiseThr, strength)
	local result = -1;
	print("SplitOverlay:setSharpParam LeftOv Id",self.left_ov.id,"RightOv Id",self.right_ov.id);
	result = self.left_ov:setSharpParam(enable, edgeThr, smoothThr, noiseThr, strength);
	if(result ~= 0) then
		print("SplitOverlay:setSharpParam LeftOv Id", self.left_ov.id, ":FAILED");
		return result;
	end
	result = self.right_ov:setSharpParam(enable, edgeThr, smoothThr, noiseThr, strength);
	if(result ~= 0) then
		print("SplitOverlay:setSharpParam RightOv Id", self.right_ov.id, ":FAILED");
		return result;
	end	return result;
end

-- Class create for videoplay in Split display
-- Create two VideoOverlay in left mixer and right mixer
-- Inherits from SplitOverlay
SplitVideoOverlay = SplitOverlay:new();

function SplitVideoOverlay:new(obj, fb)
	-- print("SplitOverlay:new");
	if(obj == nil) then
		local obj = {};
		setmetatable(obj, self);
		self.__index = self;
		return obj;
	end

	local obj1, obj2 = table.copy(obj), table.copy(obj);

	obj1.show = true;
	obj2.show = false;

	self.src = obj2.src;

	obj2.src = nil;

	local obj = AbstractOverlay:new(obj, fb);
	setmetatable(obj, self);
	self.__index = self;

	if(obj == nil) then
		return nil;
	end

	obj.vinfo = fb:getFbVarScreenInfo();

	obj.max_width = obj.vinfo.xres - fb:getRightMaxWidth();

	obj.left_ov = VideoOverlay:new(obj1, fb);

	obj.right_ov = VideoOverlay:new(obj2, fb);

	self.data = obj.left_ov:getData()

	self.mem, self.mem_back = obj.left_ov:getMem();

	obj.left_ov:setData(nil);

	obj.left_ov.mem = nil;

	obj.left_ov.mem_back = nil;

	self.cur_frame = obj.left_ov.cur_frame;

	self.frames = obj.left_ov.frames;

	self.framesize = obj.left_ov.framesize;

	if(IS_SOURCE_SPLIT_SUPPORTED == false) then
		print("Set MDSS_MDP_RIGHT_MIXER Flag ", IS_SOURCE_SPLIT_SUPPORTED);
		obj.right_ov:setFlags(bit32.bor(obj.right_ov:getFlags(), MDSS_MDP_RIGHT_MIXER));
	else
		print("Donot MDSS_MDP_RIGHT_MIXER Flag ", IS_SOURCE_SPLIT_SUPPORTED);
	end
	obj:setDstRectPosition(obj.dst_x, obj.dst_y);
	IS_SPLIT_OVERLAY_USED = true;
	print("SplitOverlay:new");
	return obj;
end

function SplitVideoOverlay:playOverlay()
	print("SplitVideoOverlay:playOverlay");
	local result = 0;

	if(self.left_ov.show == true) then
		result = result + self.fb:playOverlay(self.left_ov.overlay,
						self.data);
	end

	if(self.right_ov.show == true) then
		result = result + self.fb:playOverlay(self.right_ov.overlay,
						self.data);
	end

	local next_mem = nil;

	if(self.cur_frame % 2 ==0) then
		next_mem = self.mem_back;
	else
		next_mem = self.mem;
	end

	self.cur_frame = self.cur_frame + 1;

	if(self.cur_frame == self.frames) then
		return -1;
	end
	-- print("VP DEBUG " ,self.src, self.framesize, self.cur_frame);
	if(read_file(next_mem, self.src, self.framesize, self.framesize * self.cur_frame) <= 0) then
		return -1;
	end

	local ov_data_data = self.data.data;
	ov_data_data.memory_id = next_mem.mem_fd;
	ov_data_data.offset = 0;
	ov_data_data.flags = 0;
	self.data.data = ov_data_data;

	self.left_ov.ov_handle.ov = self.left_ov.overlay;
	self.right_ov.ov_handle.ov = self.right_ov.overlay;

	return result;
end

function SplitVideoOverlay:clear()
	-- print("SplitVideoOverlay:clear");
	self.right_ov:clear();
	self.right_ov = nil;

	self.left_ov:clear();
	self.left_ov = nil;

	if(self.mem ~= nil) then
		free_mem(self.mem);
	end

	if(self.mem_back ~= nil) then
		free_mem(self.mem_back);
	end

	fb:detachObject(self);
end

function SplitVideoOverlay:getLeftOv()
return self.left_ov;
end
function SplitVideoOverlay:getRightOv()
return self.right_ov;
end

function SplitVideoOverlay:getData()
	-- print("SplitVideoOverlay:getData");
    return self.left_ov:getData();
end

function SplitVideoOverlay:setData(data)
	-- print("SplitVideoOverlay:setData");
    self.left_ov:setData(data);
	self.right_ov:setData(data);
end

-- Set overlay.horz_deci
function SplitVideoOverlay:setHorzDeci(horz_deci)
	print("SplitVideoOverlay:setHorzDeci",horz_deci);
	self.left_ov:setHorzDeci(horz_deci);
	self.right_ov:setHorzDeci(horz_deci);
end

-- Set overlay.vert_deci
function SplitVideoOverlay:setVertDeci(vert_deci)
	print("SplitVideoOverlay:setVertDeci",vert_deci);
	self.left_ov:setVertDeci(vert_deci);
	self.right_ov:setVertDeci(vert_deci);
end

function SplitVideoOverlay:setSrcRectPosition(x, y)
	print("SplitVideoOverlay:setSrcRectPosition (x,y)",x,y);
    local src_x = x;
	local src_y = y;

	local dst_x, dst_y = self:getDstRectPosition();

	-- If the overlay's src is in the left part of screen
	-- We just display the left overlay
	if(src_x + self:getSrcRectWidth() < self.max_width) then
		self.right_ov:hideOverlay();
		self.left_ov:showOverlay();

		self.left_ov:setSrcRectPosition(src_x, src_y);
	elseif(src_x < self.max_width) then
		-- if it is right in the middle
		self.right_ov:showOverlay();
		self.left_ov:showOverlay();

		local left_src_x = src_x;
		local right_src_x = src_x + self:getSrcRectWidth() - self.max_width;

		-- If horizontal flip happen, change src_x of both overlay
		if(bit32.band(self:getFlags(), MDP_FLIP_LR) ~= 0) then
			left_src_x = self:getWidth() - right_src_x;
			right_src_x = 0;
		end

		self.left_ov:setSrcRectPosition(left_src_x, src_y);
		self.right_ov:setSrcRectPosition(right_src_x, src_y);
	else
	-- If in right mixer, only use right overlay
		self.right_ov:showOverlay();
		self.left_ov:hideOverlay();

		self.right_ov:setSrcRectPosition(src_x - self.max_width, src_y);
	end

	self.src_x = x;
	self.src_y = y;
	return 0;
end

function SplitVideoOverlay:setDstRectPosition(dst_x, dst_y)
    print("SplitVideoOverlay:setDstRectPosition (x,y)",dst_x,",",dst_y);
	local dst_x = dst_x;
	local dst_y = dst_y;

	local src_x, src_y = self:getSrcRectPosition();

	if(dst_x + self:getDstRectWidth() > self.max_width) then
		if(dst_x >= self.max_width) then
			if(self.right_ov:getDstRectWidth() > self.max_width) then
				return -1;
			end
			-- If it is in the right mixer, only right overlay
			self.right_ov:showOverlay();
			self.left_ov:hideOverlay();

			if(IS_SOURCE_SPLIT_SUPPORTED == false) then
				self.right_ov:setDstRectPosition(dst_x - self.max_width, dst_y);
			else
				self.right_ov:setDstRectPosition(dst_x, dst_y);
			end
		else
			-- in the middle
			self.right_ov:showOverlay();
			self.left_ov:showOverlay();

			local left_width = self.max_width - dst_x;

			-- Caculate the scaling ratio of the image
			local scale_w = math.ceil (self:getDstRectWidth() / self:getSrcRectWidth());

			local right_src_x = src_x + left_width / scale_w;
			local right_src_w = self.right_ov:getWidth() - left_width / scale_w;
			local left_src_w = math.ceil (left_width / scale_w);

			local left_src_x, left_src_y = self.left_ov:getSrcRectPosition();

			-- If horizontal flip happen
			if(bit32.band(self:getFlags(), MDP_FLIP_LR) ~= 0) then
				left_src_x = self:getWidth() - right_src_x;
				right_src_x = 0;
			end

			-- yuv format overlay cannot have odd src rect coordinates
			if(is_yuv(self.format) == true) then
				right_src_x = round_down_to_even(right_src_x);
				right_src_w = round_up_to_even(right_src_w);
				left_src_w = round_up_to_even(left_src_w);
				left_src_x = round_down_to_even(left_src_x);
			end

			self.right_ov:setDstRectPosition(self.max_width, dst_y);
			self.right_ov:setSrcRectPosition(right_src_x, src_y);
			self.right_ov:setDstRectWidth(self.right_ov:getWidth() - left_width);
			self.right_ov:setSrcRectWidth(right_src_w);

			self.left_ov:setDstRectPosition(dst_x, dst_y);
			self.left_ov:setSrcRectPosition(left_src_x, left_src_y);
			self.left_ov:setDstRectWidth(left_width);
			self.left_ov:setSrcRectWidth(left_src_w);

		end
	else
		-- left mixer, only left overlay
		self.right_ov:hideOverlay();
		self.left_ov:showOverlay();

		local left_width = self.max_width - dst_x;
		if(self.left_ov:getSrcRectWidth() == self.max_width/2) then
		self.left_ov:setSrcRectWidth(left_src_w);
		end
		self.left_ov:setDstRectPosition(dst_x, dst_y);
	end

	self.dst_x = dst_x;
	self.dst_y = dst_y;

	return 0;
end

function SplitVideoOverlay:setPaParam (enable, globalPadata)
	local result = -1;
	print("SplitVideoOverlay:setPaParam LeftOv Id",self.left_ov.id,"RightOv Id",self.right_ov.id);
	result = self.left_ov:setPaParam(enable, globalPadata);
	if(result ~= 0) then
		print("SplitVideoOverlay:setPaParam LeftOv Id", self.left_ov.id, ":FAILED");
		return result;
	end
	result = self.right_ov:setPaParam(enable, globalPadata);
	if(result ~= 0) then
		print("SplitVideoOverlay:setPaParam RightOv Id", self.right_ov.id, ":FAILED");
		return result;
	end
end

function SplitVideoOverlay:setCscParam (enable, cscMv, cscPreBv, cscPostBv, cscPreLv, cscPostLv)
	local result = -1;
	print("SplitVideoOverlay:setCscParam LeftOv Id",self.left_ov.id,"RightOv Id",self.right_ov.id);
	result = self.left_ov:setCscParam(enable, cscMv, cscPreBv, cscPostBv, cscPreLv, cscPostLv);
	if(result ~= 0) then
		print("SplitVideoOverlay:setCscParam LeftOv Id", self.left_ov.id, ":FAILED");
		return result;
	end
	result = self.right_ov:setCscParam(enable, cscMv, cscPreBv, cscPostBv, cscPreLv, cscPostLv);
	if(result ~= 0) then
		print("SplitVideoOverlay:setCscParam RightOv Id", self.right_ov.id, ":FAILED");
		return result;
	end
end

function SplitVideoOverlay:setIgcParam (enable, rVal, gVal, bVal)
	local result = -1;
	print("SplitVideoOverlay:setIgcParam LeftOv Id",self.left_ov.id,"RightOv Id",self.right_ov.id);
	result = self.left_ov:setIgcParam(enable, rVal, gVal, bVal);
	if(result ~= 0) then
		print("SplitVideoOverlay:setIgcParam LeftOv Id", self.left_ov.id, ":FAILED");
		return result;
	end
	result = self.right_ov:setIgcParam(enable, rVal, gVal, bVal);
	if(result ~= 0) then
		print("SplitVideoOverlay:setIgcParam RightOv Id", self.right_ov.id, ":FAILED");
		return result;
	end
end

function SplitVideoOverlay:setQseedParam (enable, data)
	local result = -1;
	print("SplitVideoOverlay:setQseedParam LeftOv Id",self.left_ov.id,"RightOv Id",self.right_ov.id);
	result = self.left_ov:setQseedParam(enable, data);
	if(result ~= 0) then
		print("SplitVideoOverlay:setQseedParam LeftOv Id", self.left_ov.id, ":FAILED");
		return result;
	end
	result = self.right_ov:setQseedParam(enable, data);
	if(result ~= 0) then
		print("SplitVideoOverlay:setQseedParam RightOv Id", self.right_ov.id, ":FAILED");
		return result;
	end
end

function SplitVideoOverlay:setSharpParam (enable, edgeThr, smoothThr, noiseThr, strength)
	local result = -1;
	print("SplitVideoOverlay:setSharpParam LeftOv Id",self.left_ov.id,"RightOv Id",self.right_ov.id);
	result = self.left_ov:setSharpParam(enable, edgeThr, smoothThr, noiseThr, strength);
	if(result ~= 0) then
		print("SplitVideoOverlay:setSharpParam LeftOv Id", self.left_ov.id, ":FAILED");
		return result;
	end
	result = self.right_ov:setSharpParam(enable, edgeThr, smoothThr, noiseThr, strength);
	if(result ~= 0) then
		print("SplitVideoOverlay:setSharpParam RightOv Id", self.right_ov.id, ":FAILED");
		return result;
	end
end

function SplitVideoOverlay:setFormat(format)
	print("SplitVideoOverlay:setFormat");
    self.left_ov:setFormat(format);
	self.right_ov:setFormat(format);
end

function SplitVideoOverlay:setHeight(height)
    print("SplitVideoOverlay:setHeight",height);
	self.height = height;
	self.left_ov:setHeight(height);
	self.right_ov:setHeight(height);
end

function SplitVideoOverlay:setWidth(width)
	print("SplitVideoOverlay:setWidth",width);
    self.width = width;
	self.left_ov:setWidth(width);
	self.right_ov:setWidth(width);
end

function SplitVideoOverlay:setDstRectHeight(height)
	print("SplitVideoOverlay:setDstRectHeight",height);
    self.dst_h = height;
	self.left_ov:setDstRectHeight(height);
	self.right_ov:setDstRectHeight(height);
end

function SplitVideoOverlay:setScale(width, height)
	print("SplitVideoOverlay:setScale (WxH)",width,"x",height);
    self:setDstRectHeight(height);
	self:setDstRectWidth(width);
end

function SplitVideoOverlay:setDstRectWidth(width)
	print("SplitVideoOverlay:setDstRectWidth",width);
    local dst_x, dst_y = self:getDstRectPosition();
	local src_x, src_y = self:getSrcRectPosition();
	if(dst_x + width <= self.max_width) then
		-- Only use left mixer
		self.right_ov:hideOverlay();
		self.left_ov:showOverlay();

		self.left_ov:setDstRectWidth(width);
	elseif(dst_x < self.max_width) then
		-- Use both overlay
		-- Here, it is actually use scale ratio and dst width to get right overlay src_rect_w
		-- Finally use src_rect_w and scale ratio to get the dst_rect_w.
		local src_w = self:getSrcRectWidth();

		-- Caculate the scale ratio
		local scale_w = math.ceil (width / self:getSrcRectWidth());

		local right_width = width + dst_x - self.max_width;

		local right_src_w = math.ceil (right_width / scale_w);
		local right_src_x = src_x + src_w - right_src_w;
		local left_src_w = src_w - right_src_w;

		local left_src_x, left_src_y = self.left_ov:getSrcRectPosition();

		-- Horizontal flip happen
		if(bit32.band(self:getFlags(), MDP_FLIP_LR) ~= 0) then
			left_src_x = self:getWidth() - right_src_x;
			right_src_x = 0;
		end

		-- Yuv format cannot have odd src_rect coordinate
		if(is_yuv(self.format) == true) then
			right_src_x = round_down_to_even(right_src_x);
			right_src_w = round_up_to_even(right_src_w);
			left_src_w = round_up_to_even(left_src_w);
			left_src_x = round_down_to_even(left_src_x);
		end

		-- src_rect_width must be larger than 1
		if(right_src_w >= 1) then
			self.right_ov:setSrcRectPosition(right_src_x, src_y);
			self.right_ov:setDstRectWidth(right_width);
			self.right_ov:setSrcRectWidth(right_src_w);
			self.right_ov:showOverlay();

			self.left_ov:setDstRectWidth(self.max_width - dst_x);
			self.left_ov:setSrcRectPosition(left_src_x, left_src_y);
			self.left_ov:setSrcRectWidth(left_src_w);
			self.left_ov:showOverlay();
		end

	else
		self.right_ov:showOverlay();
		self.left_ov:hideOverlay();

		self.right_ov:setDstRectWidth(width);
	end

	self.dst_w = width;

	return 0;
end

function SplitVideoOverlay:setSrcRectWidth(width)
	print("SplitVideoOverlay:setSrcRectWidth",width);
	local dst_x, dst_y = self:getDstRectPosition();
	local src_x, src_y = self:getSrcRectPosition();

	if(src_x + width <= self.max_width) then
		-- Only use left overlay
		self.right_ov:hideOverlay();
		self.left_ov:showOverlay();

		self.left_ov:setSrcRectWidth(width);
		self.left_ov:setSrcRectPosition(src_x, src_y);
	elseif(src_x < self.max_width) then
		-- In the middle, use both
		self.right_ov:showOverlay();
		self.left_ov:showOverlay();

		local left_src_x, left_src_y = self.left_ov:getSrcRectPosition();
		local right_src_x = self.max_width;

		-- If horizontal flip happen
		if(bit32.band(self:getFlags(), MDP_FLIP_LR) ~= 0) then
			left_src_x = self:getWidth() - right_src_x;
			right_src_x = 0;
		end

		self.left_ov:setSrcRectWidth(self.max_width - src_x);
		self.right_ov:setSrcRectPosition(left_src_x, left_src_y);
		self.right_ov:setSrcRectPosition(right_src_x, src_y);
		self.right_ov:setSrcRectWidth(src_x + width - self.max_width);
	else
		self.right_ov:showOverlay();
		self.left_ov:hideOverlay();

		self.right_ov:setSrcRectWidth(width);
	end

	self.src_w = width;
	return 0;
end

function SplitVideoOverlay:setSrcRectHeight(height)
	print("SplitVideoOverlay:setSrcRectHeight",height);
	self.src_h = height;
	self.left_ov:setSrcRectHeight(height);
	self.right_ov:setSrcRectHeight(height);
end

function SplitVideoOverlay:setFlags(flags)
	print("SplitVideoOverlay:setFlags", flags);
	local flags = flags;
	if(type(tonumber(flags)) ~= "number") then
		flags = string.upper(flags);
		flags = flags_table[flags];
	end

	self.flags = flags;

	self.left_ov:setFlags(flags);
	if(IS_SOURCE_SPLIT_SUPPORTED == false) then
		-- The MDSS_MDP_RIGHT_MIXER must be kept to push right overlay to right mixer
		self.right_ov:setFlags(bit32.bor(flags, MDSS_MDP_RIGHT_MIXER));
	end
end

function SplitVideoOverlay:setOverlay()
	print("SplitVideoOverlay:setOverlay");
	local result = self.left_ov:setOverlay();

	if(result ~=0) then
		return result;
	end

	local result = self.right_ov:setOverlay();

	if(result ~=0) then
		return result;
	end

	return 0;
end

function SplitVideoOverlay:unsetOverlay()
	print("SplitVideoOverlay:unsetOverlay");
	print("SplitVideoOverlay:unsetLeftOverlay Id ", self.left_ov:getId());
	local result = self.left_ov:unsetOverlay();
	if(result ~=0) then
		return result;
	end

	print("SplitVideoOverlay:unsetLeftOverlay Result ", result);
	print("SplitVideoOverlay:unsetRightOverlay ID", self.right_ov:getId() );
	local result = self.right_ov:unsetOverlay();
	print("SplitVideoOverlay:unsetRightOverlay Result ", result);
	if(result ~=0) then
		return result;
	end
	return 0;
end

function SplitVideoOverlay:setAlpha(alpha)
	print("SplitVideoOverlay:setAlpha", alpha);
	self.right_ov:setAlpha(alpha);
	self.left_ov:setAlpha(alpha);
	self.alpha = alpha;
end

function SplitVideoOverlay:doTransform()
	-- Function for handle horizontal flip
	print("SplitVideoOverlay:doTransform");
	if(bit32.band(self:getFlags(), MDP_FLIP_LR) ~= 0) then
		local left_src_x, left_src_y = self.left_ov:getSrcRectPosition();
		local right_src_x, right_src_y = self.right_ov:getSrcRectPosition();
		local left_src_w = self.left_ov:getSrcRectWidth();
		local right_src_w = self.right_ov:getSrcRectWidth();
		local dst_x, dst_y = self:getDstRectPosition();
		local dst_w = self:getDstRectWidth();

		if(dst_x + dst_w <= self.max_width) then
			self.left_ov:showOverlay();
			self.right_ov:hideOverlay();
		elseif(dst_x < self.max_width) then
			-- In the middle, switch the src_rect x.
			self.left_ov:showOverlay();
			self.right_ov:showOverlay();

			self.left_ov:setSrcRectPosition(self:getWidth() - right_src_x, left_src_y);
			self.right_ov:setSrcRectPosition(0, right_src_y);
		else
			self.left_ov:hideOverlay();
			self.right_ov:showOverlay();
		end
	end
end

function SplitVideoOverlay:setFlip(flip)
	print("SplitVideoOverlay:setFlip", flip);
	local flip = flip or 0;

	if(type(tonumber(flip)) ~= "number") then
		flip = string.upper(flip);
		flip = format_table[flip];
	end

	self.flip = flip;
	self:setFlags(bit32.bxor(self:getFlags(), self.flip));
	self:doTransform();
end

function SplitVideoOverlay:clear()
	-- print("SplitVideoOverlay:clear");
	self.right_ov:clear();
	self.right_ov = nil;

	self.left_ov:clear();
	self.left_ov = nil;

	fb:detachObject(self);
end

function SplitVideoOverlay:setCrop(x, y, width, height)
	print("SplitVideoOverlay:setCrop (x,y,w,h)",x, y, width, height);
	self:setDstRectPosition(x, y);
	self:setDstRectWidth(width);
	self:setDstRectHeight(height);

	self:setSrcRectPosition(x, y);
	self:setSrcRectWidth(width);
	self:setSrcRectHeight(height);
end

-- Set blend_op, can handle string input
function SplitVideoOverlay:setBlend_op(blend_op)
	print("SplitVideoOverlay:setBlend_op", blend_op);
	local blend_op = blend_op or 0;

	if(type(tonumber(blend_op)) ~= "number") then
		blend_op = string.upper(blend_op);
		blend_op = blend_op_table[blend_op];
	end

	self.blend_op = blend_op;
	self.left_ov:setBlend_op(blend_op);
	self.right_ov:setBlend_op(blend_op);
end

function SplitVideoOverlay:getLeftOv()
return self.left_ov;
end
function SplitVideoOverlay:getRightOv()
return self.right_ov;
end

function SplitVideoOverlay:getData()
	-- print("SplitVideoOverlay:getData");
    return self.left_ov:getData();
end

function SplitVideoOverlay:setData(data)
	-- print("SplitVideoOverlay:setData");
    self.left_ov:setData(data);
	self.right_ov:setData(data);
end

-- Set overlay.horz_deci
function SplitVideoOverlay:setHorzDeci(horz_deci)
	print("SplitVideoOverlay:setHorzDeci",horz_deci);
	self.left_ov:setHorzDeci(horz_deci);
	self.right_ov:setHorzDeci(horz_deci);
end

-- Set overlay.vert_deci
function SplitVideoOverlay:setVertDeci(vert_deci)
	print("SplitVideoOverlay:setVertDeci",vert_deci);
	self.left_ov:setVertDeci(vert_deci);
	self.right_ov:setVertDeci(vert_deci);
end

function SplitVideoOverlay:setSrcRectPosition(x, y)
	print("SplitVideoOverlay:setSrcRectPosition (x,y)",x,y);
    local src_x = x;
	local src_y = y;

	local dst_x, dst_y = self:getDstRectPosition();

	-- If the overlay's src is in the left part of screen
	-- We just display the left overlay
	if(src_x + self:getSrcRectWidth() < self.max_width) then
		self.right_ov:hideOverlay();
		self.left_ov:showOverlay();

		self.left_ov:setSrcRectPosition(src_x, src_y);
	elseif(src_x < self.max_width) then
		-- if it is right in the middle
		self.right_ov:showOverlay();
		self.left_ov:showOverlay();

		local left_src_x = src_x;
		local right_src_x = src_x + self:getSrcRectWidth() - self.max_width;

		-- If horizontal flip happen, change src_x of both overlay
		if(bit32.band(self:getFlags(), MDP_FLIP_LR) ~= 0) then
			left_src_x = self:getWidth() - right_src_x;
			right_src_x = 0;
		end

		self.left_ov:setSrcRectPosition(left_src_x, src_y);
		self.right_ov:setSrcRectPosition(right_src_x, src_y);
	else
	-- If in right mixer, only use right overlay
		self.right_ov:showOverlay();
		self.left_ov:hideOverlay();

		self.right_ov:setSrcRectPosition(src_x - self.max_width, src_y);
	end

	self.src_x = x;
	self.src_y = y;
	return 0;
end

function SplitVideoOverlay:setDstRectPosition(dst_x, dst_y)
    print("SplitVideoOverlay:setDstRectPosition (x,y)",dst_x,",",dst_y);
	local dst_x = dst_x;
	local dst_y = dst_y;

	local src_x, src_y = self:getSrcRectPosition();

	if(dst_x + self:getDstRectWidth() > self.max_width) then
		if(dst_x >= self.max_width) then
			if(self.right_ov:getDstRectWidth() > self.max_width) then
				return -1;
			end
			-- If it is in the right mixer, only right overlay
			self.right_ov:showOverlay();
			self.left_ov:hideOverlay();

			if(IS_SOURCE_SPLIT_SUPPORTED == false) then
				self.right_ov:setDstRectPosition(dst_x - self.max_width, dst_y);
			else
				self.right_ov:setDstRectPosition(dst_x, dst_y);
			end
		else
			-- in the middle
			self.right_ov:showOverlay();
			self.left_ov:showOverlay();

			local left_width = self.max_width - dst_x;

			-- Caculate the scaling ratio of the image
			local scale_w = math.ceil (self:getDstRectWidth() / self:getSrcRectWidth());

			local right_src_x = math.ceil (src_x + left_width / scale_w);
			local right_src_w = self.right_ov:getWidth() - left_width / scale_w;
			local left_src_w = left_width / scale_w;

			local left_src_x, left_src_y = self.left_ov:getSrcRectPosition();

			-- If horizontal flip happen
			if(bit32.band(self:getFlags(), MDP_FLIP_LR) ~= 0) then
				left_src_x = self:getWidth() - right_src_x;
				right_src_x = 0;
			end

			-- yuv format overlay cannot have odd src rect coordinates
			if(is_yuv(self.format) == true) then
				right_src_x = round_down_to_even(right_src_x);
				right_src_w = round_up_to_even(right_src_w);
				left_src_w = round_up_to_even(left_src_w);
				left_src_x = round_down_to_even(left_src_x);
			end

			self.right_ov:setDstRectPosition(self.max_width, dst_y);
			self.right_ov:setSrcRectPosition(right_src_x, src_y);
			self.right_ov:setDstRectWidth(self.right_ov:getWidth() - left_width);
			self.right_ov:setSrcRectWidth(right_src_w);

			self.left_ov:setDstRectPosition(dst_x, dst_y);
			self.left_ov:setSrcRectPosition(left_src_x, left_src_y);
			self.left_ov:setDstRectWidth(left_width);
			self.left_ov:setSrcRectWidth(left_src_w);

		end
	else
		-- left mixer, only left overlay
		self.right_ov:hideOverlay();
		self.left_ov:showOverlay();

		local left_width = self.max_width - dst_x;
		if(self.left_ov:getSrcRectWidth() == self.max_width/2) then
		self.left_ov:setSrcRectWidth(left_src_w);
		end
		self.left_ov:setDstRectPosition(dst_x, dst_y);
	end

	self.dst_x = dst_x;
	self.dst_y = dst_y;

	return 0;
end

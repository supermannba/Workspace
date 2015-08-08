SLB.using(SLB.FBTest);

local wb_format_map = {};

-- MDP Capabilities Globals Available in Object wrappes as well
MDP3_REV = tonumber("305");
MDP_REV = 0;
MDP_REV_MAJOR = 0;
MDP_REV_MINOR = 0;
MAX_RGB_PIPE = 0;
MAX_VIG_PIPE = 0;
MAX_DMA_PIPE = 0;
MAX_SMP_COUNT = 0;
MAX_SMP_SIZE = 0;
MAX_UP_SCALE = 0;
MAX_DOWN_SCALE = 0;
MAX_MIXER_WIDTH_LUA = 0;
IS_BWC_SUPPORTED = false;
IS_DECIMATION_SUPPORTED = false;
IS_TILE_FORMAT_SUPPORTED = false;
IS_SOURCE_SPLIT_SUPPORTED = false;
IS_SPLIT_OVERLAY_USED = false;
IS_RGB_SCALING_SUPPORTED = true;
IS_ROTATOR_DOWN_SCALING_SUPPORTED = false;
wb_format_map[WB_FORMAT_NV12] = MDP_Y_CBCR_H2V2_VENUS;
wb_format_map[WB_FORMAT_RGB_565] = MDP_RGB_565;
wb_format_map[WB_FORMAT_RGB_888] = MDP_RGB_888;
wb_format_map[WB_FORMAT_xRGB_8888] = MDP_XRGB_8888;
wb_format_map[WB_FORMAT_ARGB_8888] = MDP_ARGB_8888;
wb_format_map[WB_FORMAT_BGRA_8888] = MDP_BGRA_8888;
wb_format_map[WB_FORMAT_BGRX_8888] = MDP_BGRX_8888
wb_format_map[WB_FORMAT_ARGB_8888_INPUT_ALPHA] = 0;

local wb_dump_format_map = {};
wb_dump_format_map[WB_FORMAT_NV12] = "_Y_CBCR_H2V2_VENUS";
wb_dump_format_map[WB_FORMAT_RGB_565] = "_RGB_565";
wb_dump_format_map[WB_FORMAT_RGB_888] = "_RGB_888";
wb_dump_format_map[WB_FORMAT_xRGB_8888] = "_XRGB_8888";
wb_dump_format_map[WB_FORMAT_ARGB_8888] = "_ARGB_8888";
wb_dump_format_map[WB_FORMAT_BGRA_8888] = "_BGRA_8888";
wb_dump_format_map[WB_FORMAT_BGRX_8888] = "_BGRX_8888";
wb_dump_format_map[WB_FORMAT_ARGB_8888_INPUT_ALPHA] = "_ARGB_8888_INPUT_ALPHA";

-- MAP MISR ID to MISR Name
misrName ={};
misrName[DISPLAY_MISR_EDP] = "EDP";
misrName[DISPLAY_MISR_DSI0] = "DSI0";
misrName[DISPLAY_MISR_DSI1] = "DSI1";
misrName[DISPLAY_MISR_HDMI] = "HDMI";
misrName[DISPLAY_MISR_LCDC] = "LCDC";
misrName[DISPLAY_MISR_MDP] = "MDP";
misrName[DISPLAY_MISR_ATV] = "ATV";
misrName[DISPLAY_MISR_DSI_CMD] = "DSI_CMD";

--BlitType
SYNC_BLIT = 0;
ASYNC_BLIT = 1;
BLT_BUFF_SWAP = 0;

-- Factory for framebuffer
FrameBufferFactory = {}

-- Track ovunset call
local overlayUnsetDone = false;
-- Track batch mode CRC operation
local batchModeCRCEnable = false;
-- Create a list of framebuffers, and other type of framebuffer
-- The first list includes all framebuffers
function FrameBufferFactory:createFrameBuffers(framebuffers)
	print("FrameBufferFactory:createFrameBuffers ", type);
	local main = {};
	local hdmi = {};
	local wfd = {};
	local writeback = {};
	local pandisplay = {};
	local all = {};
	local result = {};
	result["main"] = main;
	result["hdmi"] = hdmi;
	result["wfd"] = wfd;
	result["writeback"] = writeback;
	result["pandisplay"] = pandisplay;
	result["all"] = all;

	for k, v in pairs(framebuffers) do
		local fbType;
		print("framebuffers Param  ", v.fb_type ,v.crc_path, v.crc_mode);
		if(v.fb_type ~= nil) then
			fbType = string.lower(v.fb_type);
			print("fbType = ", fbType);
		end

		local fb = self:createFrameBuffer(v);

		if(fbType ~= nil) then
			table.insert(result[fbType], fb);
		end

		table.insert(result["all"], fb);
	end

	return all, main, hdmi, wfd, writeback, pandisplay;
end

-- Create a single framebuffer
function FrameBufferFactory:createFrameBuffer(framebuffer)

	local fbType = framebuffer.fb_type;
	local ndx = framebuffer.ndx or 0;
	if(fbType ~= nil) then
		fbType = string.lower(fbType);
	end

	if(fbType ~= nil) then
        print("FrameBufferFactory: createPrimaryFrameBuffer of type <", fbType, ">");
		if(fbType == "main") then
			return PrimaryFrameBuffer:new(framebuffer);
		elseif (fbType == "hdmi") then
			return HdmiFrameBuffer:new(framebuffer);
		elseif (fbType == "wfd") then
			return WfdFrameBuffer:new(framebuffer);
		elseif (fbType == "writeback") then
			return WriteBackFrameBuffer:new(framebuffer);
		elseif (fbType == "pandisplay") then
			return PanDisplayFrameBuffer:new(framebuffer);
		end
	end
	print("FrameBufferFactory:createFrameBuffer of type <Deafult>");
	return FrameBuffer:new(framebuffer, ndx);
end

-- Base class of framebuffer
FrameBuffer = {}

-- Create a new Framebuffer
function FrameBuffer:new(obj, index)
	print("FrameBuffer:new");
	--Create a new list
	local obj = obj or {};
	--Change the prototype to simulate OOP
	setmetatable(obj, self);
	self.__index = self;

	obj.objects = {};
	if(obj.crc_path ~= nil) then
		if(obj.crc_mode == "generation") then
			print("CRC MODE : Gen ", obj.crc_path);
			obj.crc_file = io.open(obj.crc_path, "w+");
			print("CRC db file ",obj.crc_file );
		elseif(obj.crc_mode == "validation") then
			print("CRC MODE : Valid ", obj.crc_path);
			obj.crc_file = io.open(obj.crc_path, "r");
			obj.report_file = io.open(obj.crc_path..".report", "w+");
			print("CRC db file ",obj.crc_file , obj.report_file);
		else
			print("Invalid CRC mode selected <", obj.crc_mode, ">");
			print("CRC mode should be <generation/validation>");
			error("Invalid CRC mode selected ");
			self:clear();
		end
	end
	print("FrameBuffer:new ",obj.crc_file , obj.report_file);
	if(index == nil) then
		return obj;
	end

	obj.fb_handle = create_fb_handle(index);

	local vinfo = obj:getFbVarScreenInfo();
	obj.vinfo = vinfo;
	obj.fb_handle.fb_name = "deafult main";
	print("Default MISR Block ID ", obj.fb_handle.crc_block_num);
	obj:getMdpCaps();
	print("MDP HW Rev ",obj:getMdpVersion());
	return obj;
end

function FrameBuffer:toString()
	local result = "{";
	--result = result .. string.format("%s = \"%s\",", "crc_block_num", tostring(self.fb_handle.crc_block_num));
	--result = result .. string.format("%s = \"%s\",", "fb_right_split", tostring(self.fb_handle.fb_right_split));
	--result = result .. string.format("%s = \"%s\",", "fd", tostring(self.fb_handle.fd));
	--result = result .. string.format("%s = \"%s\",", "smem_len", tostring(self.fb_handle.finfo.smem_len));
	result = result .. string.format("%s = \"%s\"", "fb_name", tostring(self.fb_handle.fb_name));
	-- print("fb_name", self.fb_handle.fb_name);
	for k, v in pairs(self.objects) do
        if(v.overlay ~= nil) then
		if((v.overlay.id < 4294967295) and (v.overlay.id > 0)) then
			result = result .. v:toString();
			print("Overlay ID = ", v.overlay.id, result);
		end
        end
	end
	-- print("result =", result);
	return result .."}";
end

-- Get the right split of framebuffer
function FrameBuffer:getRightMaxWidth()
	-- print("FrameBuffer:getRightMaxWidth");
	if ((self.fb_handle.fb_right_split == 0) and (self.vinfo.xres > 2048)) then
		return self.vinfo.xres / 2;
	else
		return self.fb_handle.fb_right_split;
	end
end

function FrameBuffer:crcOperation()
	if(batchModeCRCEnable == true) then
	return 0;
	end
	-- print("FrameBuffer:crcOperation");
	if(overlayUnsetDone == false) then
	if(self.crc_mode == "generation" or self.crc_mode == "validation") then
	-- sleep(100000);
	local crc1;
	-- Get CRC for DSI1
	local dualDsi = false;
	print("self:getRightMaxWidth = ",self:getRightMaxWidth());
	if (self:getRightMaxWidth() ~= 0) then
		dualDsi = true;
		print("Src Split Enable");
	end
        if (MAX_MIXER_WIDTH_LUA > MAX_MIXER_WIDTH) then
                dualDsi = true;
                print("Dst Split Enable");
        end

	local crc = 0;
	if((tonumber(MDP_REV_MAJOR) == 10) and (tonumber(MDP_REV_MINOR) >= 3) and (self.fb_handle.fb_name == "main")) then
		self:setMisr(1, DISPLAY_MISR_DSI0);
		if(dualDsi == true) then
			self:setMisr(1, DISPLAY_MISR_DSI1);
		end
		sleep(5000);
		crc = self:getCrc(DISPLAY_MISR_DSI0);
		if(dualDsi == true) then
			crc1 = self:getCrc(DISPLAY_MISR_DSI1);
			if(crc1 < 0) then
				crc1 = 4294967296 + crc1;
			end
		end
	else
		if(self.fb_handle.fb_name ~= "writeback") then
			self:setMisr(1);
		end
		if((self.fb_handle.fb_name == "hdmi") and (IS_SPLIT_OVERLAY == true)) then
			sleep(25000);
		else
			sleep(5000);
		end
		crc = self:getCrc();
	end
	--signed to unsigned conversion
	if(crc < 0) then
		crc = 4294967296 + crc;
	end

	if(crc == 0) then
		return -1;
	end
	if((dualDsi == true) and (self.fb_handle.fb_name == "main")) then
		print("crc Value <", misrName[self.fb_handle.crc_block_num], string.format("%X", crc), ">", " <", misrName[DISPLAY_MISR_DSI1], string.format("%X", crc1), ">\n");
        else
		print("crc Value <", misrName[self.fb_handle.crc_block_num], string.format("%X", crc), ">\n");
        end
	print("FrameBuffer:crcOperation ", self.crc_file , self.report_file);
	if(self.crc_mode == "generation") then
		if((dualDsi == true) and (self.fb_handle.fb_name == "main")) then
			self.crc_file:write(self:toString().." crc0 = "..string.format("%X", crc).." crc1 = "..string.format("%X", crc1).."\"\n");
			print("crcOperation : generate <CRC0 ", string.format("%X", crc), "CRC1 ", string.format("%X", crc1), ">\n");
		else
			self.crc_file:write(self:toString().." crc = \""..string.format("%X", crc).."\"\n");
			print("crcOperation : generate <CRC ", string.format("%X", crc), ">\n");
		end
	elseif(self.crc_mode == "validation") then
		local str;
		if((dualDsi == true) and (self.fb_handle.fb_name == "main"))then
			str = self:toString().." crc0 = "..string.format("%X", crc).." crc1 = "..string.format("%X", crc1).."\"";
		else
			str = self:toString().." crc = \""..string.format("%X", crc).."\"";
		end
		local str_cmp = self.crc_file:read("*line");
		-- print("crcOperation : validation <CRC ", string.format("%X", crc), string.format("%X", crc1), "Ref_CRC ",str_cmp, ">\n");
		if(str ~= str_cmp) then
			print("STR ", str, "\n", str_cmp, "\n");
			error("Crc Validation failed");
			-- print ("Crc Validation failed");
			local crc_result = str..": MISS_MATCH\n";
			print(": MISS_MATCH\n");
			self.report_file:write(crc_result);
			-- self:clear();
		else
			print(": MATCH\n");
			local crc_result = str..": MATCH\n";
			self.report_file:write(crc_result);
		end
	end
	end
	else
		print("crcOperation : CRC Call is not required after UnsetOverlay\n");
	end
	return 0;
end

-- Call iopan_display
function FrameBuffer:iopanDisplay(vinfo)
	-- print("FrameBuffer:iopanDisplay");
	local result = iopan_display(self.fb_handle, vinfo);

	if(self:crcOperation() == -1) then
		return -1;
	end

	return result;
end

-- call cursor to set cursor
function FrameBuffer:cursor(cur)
	-- print("FrameBuffer:cursor");
    return cursor(self.fb_handle, cur.fb_cur);
end

function FrameBuffer:getMetadata(op, flags)
	-- print("FrameBuffer:getMetadata");
	local metadata = msmfb_metadata();

	metadata.op = op;
	metadata.flags = flags;

	get_metadata(self.fb_handle, metadata);

	return metadata;
end

function FrameBuffer:setMetadata(metadata)
	-- print("FrameBuffer:setMetadata");
	return set_metadata(self.fb_handle, metadata);
end

-- Call get_fb_var_screeninfo
function FrameBuffer:getFbVarScreenInfo()
	-- print("FrameBuffer:getFbVarScreenInfo");
	local vinfo = fb_var_screeninfo();

	get_fb_var_screeninfo(self.fb_handle, vinfo);

	return vinfo;
end

function FrameBuffer:getBlitData()
	local blit_req = mdp_blit_req();
	return blit_req;
end

-- Call get_fb_fix_screeninfo
function FrameBuffer:getFbFixScreenInfo()
	-- print("FrameBuffer:getFbVarScreenInfo");
	local fixinfo = fb_fix_screeninfo();

	get_fb_fix_screeninfo(self.fb_handle, fixinfo);

	return fixinfo;
end

-- call put_fb_var_screeninfo
function FrameBuffer:putFbVarScreenInfo(vinfo)
	-- print("FrameBuffer:putFbVarScreenInfo");
    return put_fb_var_screeninfo(self.fb_handle, vinfo);
end

-- call get_overlay
function FrameBuffer:getOverlay(ov)
	-- print("FrameBuffer:getOverlay");
    return get_overlay(self.fb_handle, ov);
end

-- call set_overlay
function FrameBuffer:setOverlay(ov)

    overlayUnsetDone = false;
    print("FrameBuffer:setOverlay");
    return set_overlay(self.fb_handle, ov);
end

-- call prepare_all_overlay
function FrameBuffer:prepareAllOverlay()
	print("FrameBuffer:prepareAllOverlay");

	return prepare_all_overlay(self.fb_handle);
end

-- call mdp_ov_pa
function FrameBuffer:setOverlayPaParam(ov, pa_data)

    print("FrameBuffer:setOverlayPaParam");
    return mdp_ov_pa(self.fb_handle, pa_data, ov, MDP_REV);
end

-- call mdp_ov_csc
function FrameBuffer:setOverlayCscParam(ov, csc_cfg)

    print("FrameBuffer:setOverlayCscParam");
    return mdp_ov_csc(self.fb_handle, csc_cfg, ov);
end

-- call setOverlayIgc
function FrameBuffer:setOverlayIgcParam(ov, igcLut)

    print("FrameBuffer:setOverlayIgcParam");
    return mdp_ov_igc(self.fb_handle, igcLut, ov);
end

-- call setOverlayQseedParam
function FrameBuffer:setOverlayQseedParam(ov, ops, data)

    print("FrameBuffer:setOverlayQseedParam");
    return mdp_ov_qseed(self.fb_handle, ops, data, ov);
end

-- call setOverlaySharpParam
function FrameBuffer:setOverlaySharpParam(ov, sharp_cfg)

    print("FrameBuffer:setOverlaySharpParam");
    return mdp_ov_sharp(self.fb_handle, sharp_cfg, ov);
end

-- call unset_overlay
function FrameBuffer:unsetOverlay(ov)

    overlayUnsetDone = true;
    print("FrameBuffer:unsetOverlay");
    return unset_overlay(self.fb_handle, ov);
end

-- call play_overlay
function FrameBuffer:playOverlay(ov, ov_data)
    -- print("FrameBuffer:playOverlay");
	return play_overlay(self.fb_handle, ov, ov_data);
end

-- call blit
function FrameBuffer:blit(blitType, req)
	local result = 0;
	print("FrameBuffer:blit blitType ", blitType);

	if (blitType == SYNC_BLIT) then
	result = blit(self.fb_handle, req);
	else
	result = asyncblit(self.fb_handle, req);
	end
	return result;
end

function FrameBuffer:playOverlay(ov, ov_data)
    -- print("FrameBuffer:playOverlay");
	return play_overlay(self.fb_handle, ov, ov_data);
end

-- Call perform_rotate
function FrameBuffer:performRotate(ov, ov_data, ov_data_dst)
    -- print("FrameBuffer:performRotate");
	return perform_rotate(self.fb_handle, ov, ov_data, ov_data_dst);
end

-- call display_commit
function FrameBuffer:displayCommit()

	local result = display_commit(self.fb_handle);
	print("FrameBuffer:displayCommit" , result);
	if(self:crcOperation() == -1) then
		return -1;
	end
	return result;
end

-- Attach object to the framebuffer, for garbage collection
function FrameBuffer:attachObject(obj)
	-- print("FrameBuffer:attachObject");
	self.objects[#self.objects+1] = obj;
	obj.seq_id = #self.objects;
end

-- detach object to the framebuffer, for garbage collection
function FrameBuffer:detachObject(obj)
	-- print("FrameBuffer:detachObject");
	self.objects[obj.seq_id] = nil;
end

-- Call set_misr, misr_block_id can be set or default fb type
function FrameBuffer:setMisr(frame_count, misr_block_id)
	-- print("FrameBuffer:setMisr");
	local misr_block_id = misr_block_id or self.fb_handle.crc_block_num;
	print("FrameBuffer:setMisr ID = ", misr_block_id);
	return set_misr(self.fb_handle, misr_block_id, frame_count);
end

-- Call get_crc, misr_block_id can be set or default fb type
function FrameBuffer:getCrc(misr_block_id)
	-- print("FrameBuffer:getCrc");
	local misr_block_id = misr_block_id or self.fb_handle.crc_block_num;
	print("FrameBuffer:getCrc ID = ", misr_block_id);
	return get_crc(self.fb_handle, misr_block_id);
end

-- Call start_batch_crc, misr_block_id can be set or default fb type
function FrameBuffer:startBatchCrc(misr_block_id)
	-- print("FrameBuffer:startBatchCrc");
	local misr_block_id = misr_block_id or self.fb_handle.crc_block_num;
	batchModeCRCEnable = true;
	return start_batch_crc(self.fb_handle, misr_block_id);
end

-- Call stop_batch_crc, misr_block_id can be set or default fb type
function FrameBuffer:stopBatchCrc(misr_block_id)
	-- print("FrameBuffer:stopBatchCrc");
	local misr_block_id = misr_block_id or self.fb_handle.crc_block_num;
	batchModeCRCEnable = false;
	return stop_batch_crc(self.fb_handle, misr_block_id);
end

-- Call get_batch_crc, misr_block_id can be set or default fb type
function FrameBuffer:getBatchCrc(misr_block_id)
	-- print("FrameBuffer:getBatchCrc");
	local misr_block_id = misr_block_id or self.fb_handle.crc_block_num;

	return get_batch_crc(self.fb_handle, misr_block_id);
end

-- Clear the framebuffer, clear all object, and destroy fb_handle
function FrameBuffer:clear()
	-- print("FrameBuffer:clear");
	for k, v in pairs(self.objects) do
		v:clear();
	end

	-- call commit to make unset happen
	self:displayCommit();

	destroy_fb_handle(self.fb_handle);
end

-- call set LPM mode
function FrameBuffer:enableLpmMode()
    print("FrameBuffer:lpm_control Enable LPM");
    return lpm_control(self.fb_handle, 1);
end
function FrameBuffer:disableLpmMode()
    print("FrameBuffer:lpm_control Disable LPM");
    return lpm_control(self.fb_handle, 0);
end

-- call set Display Power mode
function FrameBuffer:displayON()
    print("FrameBuffer:display_on_off Display ON");
    return fb_blank(self.fb_handle, FB_BLANK_UNBLANK);
end
function FrameBuffer:displayOFF()
    overlayUnsetDone = true;
    print("FrameBuffer:display_on_off Display OFF");
    return fb_blank(self.fb_handle, FB_BLANK_POWERDOWN);
end

-- Class for pan display, inherit from framebuffer
PanDisplayFrameBuffer = FrameBuffer:new()

-- Create a new PanDisplayFrameBuffer
function PanDisplayFrameBuffer:new(obj)
	print("PanDisplayFrameBuffer:new");
	local obj = FrameBuffer:new(obj, 0);
	setmetatable(obj, self);
	self.__index = self;

	obj.vinfo = obj:getFbVarScreenInfo();
	obj.fb_handle.fb_name = "pandisplay";
	local overlay = mdp_overlay();
	overlay.id = 200278207;
	obj:unsetOverlay(overlay);
	obj:getMdpCaps();
	return obj;
end

-- Set offsets for vinfo
function PanDisplayFrameBuffer:setVinfoOffset(xoffset, yoffset)
	print("PanDisplayFrameBuffer:setVinfoOffset (x,y)", xoffset, yoffset);
	self.vinfo.xoffset = xoffset;
	self.vinfo.yoffset = yoffset;
end

-- Get offset for vinfo
function PanDisplayFrameBuffer:getVinfoOffset()
	-- print("PanDisplayFrameBuffer:getVinfoOffset");
	return self.vinfo.xoffset, self.vinfo.yoffset;
end

function PanDisplayFrameBuffer:setVinfo(vinfo)
	print("PanDisplayFrameBuffer:setVinfo", vinfo);
	self.vinfo = vinfo;
end

-- Call iopan_display
function PanDisplayFrameBuffer:iopanDisplay()
	-- print("PanDisplayFrameBuffer:iopanDisplay");
	local result = iopan_display(self.fb_handle, self.vinfo);

	if(self:crcOperation() == -1) then
		return -1;
	end

	return result;
end

-- Call draw_buffer
function PanDisplayFrameBuffer:drawBuffer(color, format, width, height, xoffset, yoffset)
	print("PanDisplayFrameBuffer:drawBuffer");
	return draw_buffer(self.fb_handle, color, format, width, height, xoffset, yoffset);
end

-- Class for primary framebuffer, inherit from framebuffer
PrimaryFrameBuffer = FrameBuffer:new()

-- Create a new PrimaryFrameBuffer
function PrimaryFrameBuffer:new(obj)
	print("PrimaryFrameBuffer:new");
	local obj = FrameBuffer:new(obj,0);
	setmetatable(obj, self);
	self.__index = self;
	obj.fb_handle.fb_name = "main";
	print("Primary MISR Block ID ",obj.fb_handle.crc_block_num);
	return obj;
end

-- Class for hdmi framebuffer, inherits from framebuffer
HdmiFrameBuffer = FrameBuffer:new()

-- create a new HdmiFrameBuffer
function HdmiFrameBuffer:new(obj)
	-- print("HdmiFrameBuffer:new");
	local obj = FrameBuffer:new(obj);
	setmetatable(obj, self);
	self.__index = self;

	obj.fb_handle = create_hdmi_fb_handle();
	obj.fb_handle.fb_name = "hdmi";
	print("HDMI MISR Block ID ",obj.fb_handle.crc_block_num);
	obj.vinfo = obj:getFbVarScreenInfo();
	obj:getMdpCaps();
	return obj;
end

-- Class for wfd Framebuffer, inherits from framebuffer
WfdFrameBuffer = FrameBuffer:new()

-- Create a new WfdFrameBuffer
function WfdFrameBuffer:new(obj)
	-- print("WfdFrameBuffer:new");
	local obj = FrameBuffer:new(obj);
	setmetatable(obj, self);
	self.__index = self;

	obj.fb_handle = create_wfd_fb_handle();
	obj.fb_handle.fb_name = "wfd";
	print("WFD MISR Block ID ",obj.fb_handle.crc_block_num);
	obj.vinfo = obj:getFbVarScreenInfo();
	obj:getMdpCaps();
	return obj;
end

-- Class for writeback framebuffer, inherits from framebuffer
-- This Class is used for writeback file dumping.
-- It will generate a yuv file which record the running process of the testcases
WriteBackFrameBuffer = FrameBuffer:new()

-- Create a new WriteBackFrameBuffer, start writeback
function WriteBackFrameBuffer:new(obj)
	-- print("WriteBackFrameBuffer:new");
	local obj = FrameBuffer:new(obj);
	local wb_format, metadata;
	setmetatable(obj, self);
	self.__index = self;

	obj.fb_handle = create_wfd_fb_handle();
	print("writeback_init");
	writeback_init(obj.fb_handle);
	print("writeback_start");
	writeback_start(obj.fb_handle);

	local vinfo = obj:getFbVarScreenInfo();
	obj:getMdpCaps();
	obj.vinfo = vinfo;

	-- obj.output_framesize = get_frame_size(MDP_Y_CRCB_H2V2, obj.width, obj.height);
	if ((obj.write_back_format == nil) or (obj.write_back_format == WB_FORMAT_NV12)) then
		obj.width = VENUS_Y_STRIDE(COLOR_FMT_NV12, obj.vinfo.xres);
		obj.height = VENUS_Y_SCANLINES(COLOR_FMT_NV12, obj.vinfo.yres);
		obj.output_framesize = get_frame_size(MDP_Y_CRCB_H2V2, obj.width, obj.height);
		metadata = obj:getMetadata(metadata_op_wb_format, 1);
		wb_format = wb_format_map[metadata.data.mixer_cfg.writeback_format];
	else
		obj.width = obj.vinfo.xres;
		obj.height = obj.vinfo.yres;
		wb_format = wb_format_map[obj.write_back_format];
		obj.output_framesize = get_frame_size(wb_format, obj.width, obj.height);
		print("writeback_setOutputFormat to ", wb_format, "output_framesize ", obj.output_framesize);
		writeback_setOutputFormat(obj.fb_handle, wb_format);
	end
	print("Output W ",obj.width," H ",obj.height," Format ", wb_format, "Size ", obj.output_framesize);

	obj.framesize = get_frame_size(wb_format, obj.width, obj.height);

	obj.mem = alloc_mem(obj.framesize);

	obj.mem_back = alloc_mem(obj.framesize);

	local fbdata = msmfb_data();

	fbdata.offset = 0;
	fbdata.memory_id = obj.mem.mem_fd;
	fbdata.id = 0;
	fbdata.flags = 0;
	fbdata.iova = 0;

	obj.fbdata = fbdata;
	obj.cur_mem = obj.mem;
	obj.cur_frame = 0;

	if(obj.write_back_path ~= nil) then
		local time = os.time();
		if(obj.write_back_format ~= nil) then
			obj.write_back_path_yuv = "dump_"..time.."_"..obj.width.."x"..obj.height..wb_dump_format_map[obj.write_back_format]..".rgb";
			obj.write_back_path_config = "dump_"..time.."_"..obj.width.."x"..obj.height..wb_dump_format_map[obj.write_back_format]..".lua";
		else
			obj.write_back_path_yuv = "dump_"..time.."_"..obj.width.."x"..obj.height.."_Y_CBCR_H2V2.yuv";
			obj.write_back_path_config = "dump_"..time.."_"..obj.width.."x"..obj.height.."_Y_CBCR_H2V2_config.lua";
		end

		print("Write back dump file generated: "..obj.write_back_path..obj.write_back_path_yuv);
		print("Write back dump config file generated: "..obj.write_back_path..obj.write_back_path_config);

		local config_file = io.open(obj.write_back_path..obj.write_back_path_config, "w+");
		local config_file_content = "SLB.using(SLB.FBTest); parameters = { { src = \""..obj.write_back_path..obj.write_back_path_yuv
									.."\"; width = "..obj.width.."; height = "..obj.height.."; dst_w = 720; dst_h = 1280; format = MDP_Y_CRCB_H2V2; type = \"video\" }};";
		config_file:write(config_file_content);
		config_file:close();
	end

	obj.fb_handle.fb_name = "writeback";
	print("WFD MISR Block ID ",obj.fb_handle.crc_block_num);
	return obj;
end

-- call display_commit, push and pull writeback buffer
function WriteBackFrameBuffer:dequeue_buffer(dump)
	local fbdata = self.fbdata;

	fbdata.offset = 0;
	fbdata.memory_id = self.cur_mem.mem_fd;
	fbdata.id = 0;
	fbdata.flags = 0;
	fbdata.iova = 0;

	print("writeback_dequeue_buffer");
	local result = writeback_dequeue_buffer(self.fb_handle, self.fbdata);
	if((self.write_back_path ~= nil) and (dump == true)) then
		write_file(self.cur_mem, self.write_back_path..self.write_back_path_yuv, self.output_framesize, self.output_framesize * self.cur_frame);
	end
	if(self.cur_frame % 2 == 0) then
		self.cur_mem = self.mem_back;
	else
		self.cur_mem = self.mem;
	end

	self.cur_frame = self.cur_frame + 1;

	return result;
end

function WriteBackFrameBuffer:queue_buffer()
	local fbdata = self.fbdata;

	fbdata.memory_id = self.cur_mem.mem_fd;

	fbdata.flags = MSMFB_WRITEBACK_DEQUEUE_BLOCKING;
	self.fbdata = fbdata;
	print("writeback_queue_buffer");
	local result = writeback_queue_buffer(self.fb_handle, self.fbdata);
	return result;
end

function WriteBackFrameBuffer:displayCommit()
	print("WriteBackFrameBuffer:displayCommit");
	if(overlayUnsetDone == false) then
	print("WriteBackFrameBuffer:Set MISR");
	self:setMisr(1);
	end

	local result = display_commit(self.fb_handle);
	if(self:crcOperation() == -1) then
		self:dequeue_buffer(false);
		self:queue_buffer();
		local result = display_commit(self.fb_handle);
		if(self:crcOperation() == -1) then
			return -1;
		end
	end
	return result;
end

-- Clear framebuffer, terminate writeback
function WriteBackFrameBuffer:clear()
	-- print("WriteBackFrameBuffer:clear");
	for k, v in pairs(self.objects) do
		v:clear();
	end

	-- call commit to make unset happen
	self:displayCommit();

	writeback_stop(self.fb_handle);
	print("writeback_terminate");
	writeback_terminate(self.fb_handle);

	free_mem(self.mem);
	free_mem(self.mem_back);

	destroy_fb_handle(self.fb_handle);
end

function FrameBuffer:getMdpCaps()
	local cap = "/sys/class/graphics/fb0/mdp/caps";
	capFd = io.open(cap, "r");
	if(capFd == nil) then
		print(cap, " open : FAILED");
		return -1;
	end
	local continue = true;
	while continue == true do
		local str_cmp = capFd:read("*line");
		if(str_cmp == nill) then
			continue = false;
		else
			if(string.find(str_cmp,"hw_rev") ~= nil) then
				local mdpRev = string.match(str_cmp , "%d+");
				MDP_REV = tonumber(mdpRev);
				local mdp_version_major = bit32.rshift (mdpRev, 24);
				local mdp_version_minor = bit32.lshift (mdpRev, 8);
				mdp_version_minor = bit32.rshift (mdp_version_minor, 24);
				MDP_REV_MAJOR = string.format("%x",mdp_version_major);
				MDP_REV_MINOR = string.format("%x",mdp_version_minor);
				print("MDP_HW REV", MDP_REV, "MDP_REV_MAJOR ", MDP_REV_MAJOR, "MDP_REV_MINOR ", MDP_REV_MINOR);
			end
			if(string.find(str_cmp, "rgb_pipes") ~= nil) then
				MAX_RGB_PIPE = string.match(str_cmp , "%d+");
				print("MAX_RGB_PIPE ", MAX_RGB_PIPE);
			end
			if(string.find(str_cmp, "vig_pipes") ~= nil) then
				MAX_VIG_PIPE = string.match(str_cmp , "%d+");
				print("MAX_VIG_PIPE ", MAX_VIG_PIPE);
			end
			if(string.find(str_cmp, "dma_pipes") ~= nil) then
				MAX_DMA_PIPE = string.match(str_cmp , "%d+");
				print("MAX_DMA_PIPE ", MAX_DMA_PIPE);
			end

			if(string.find(str_cmp, "smp_count") ~= nil) then
				MAX_SMP_COUNT = string.match(str_cmp , "%d+");
				print("MAX_SMP_COUNT ", MAX_SMP_COUNT);
			end

			if(string.find(str_cmp, "smp_size") ~= nil) then
				MAX_SMP_SIZE = string.match(str_cmp , "%d+");
				print("MAX_SMP_SIZE ", MAX_SMP_SIZE);
			end

			if(string.find(str_cmp, "max_downscale_ratio") ~= nil) then
				MAX_DOWN_SCALE = string.match(str_cmp , "%d+");
				print("MAX_DOWN_SCALE ", MAX_DOWN_SCALE);
			end
			if(string.find(str_cmp, "max_upscale_ratio") ~= nil) then
				MAX_UP_SCALE = string.match(str_cmp , "%d+");
				print("MAX_UP_SCALE ", MAX_UP_SCALE);
			end
			if(string.find(str_cmp, "max_mixer_width") ~= nil) then
				MAX_MIXER_WIDTH_LUA = string.match(str_cmp , "%d+");
				if(MAX_MIXER_WIDTH_LUA == nil) then
					MAX_MIXER_WIDTH_LUA = MAX_MIXER_WIDTH;
				else
					MAX_MIXER_WIDTH_LUA = tonumber(MAX_MIXER_WIDTH_LUA);
				end
				print("MAX_MIXER_WIDTH_LUA ", MAX_MIXER_WIDTH_LUA);
			end
			if(string.find(str_cmp, "features") ~= nil) then
				if(string.find(str_cmp, "bwc") ~= nil) then
					IS_BWC_SUPPORTED = true;
				end
				print("IS_BWC_SUPPORTED ", IS_BWC_SUPPORTED);
				if(string.find(str_cmp, "decimation") ~= nil) then
					IS_DECIMATION_SUPPORTED = true;
				end
				print("IS_DECIMATION_SUPPORTED ", IS_DECIMATION_SUPPORTED);
				if(string.find(str_cmp, "tile_format") ~= nil) then
					IS_TILE_FORMAT_SUPPORTED = true;
				end
				print("IS_TILE_FORMAT_SUPPORTED ", IS_TILE_FORMAT_SUPPORTED);
				if(string.find(str_cmp, "src_split") ~= nil) then
					IS_SOURCE_SPLIT_SUPPORTED = true;
				end
				print("IS_SOURCE_SPLIT_SUPPORTED ", IS_SOURCE_SPLIT_SUPPORTED);
				if(string.find(str_cmp, "non_scalar_rgb") ~= nil) then
					IS_RGB_SCALING_SUPPORTED = false;
				end
				print("IS_RGB_SCALING_SUPPORTED ", IS_RGB_SCALING_SUPPORTED);
				if(string.find(str_cmp, "rotator_downscale") ~= nil) then
					IS_ROTATOR_DOWN_SCALING_SUPPORTED = true;
				end
				print("IS_ROTATOR_DOWN_SCALING_SUPPORTED ",
                                      IS_ROTATOR_DOWN_SCALING_SUPPORTED);
			end
		end
	end
	capFd:close();
end

function FrameBuffer:getMdpVersion()
	return MDP_REV_MAJOR, MDP_REV_MINOR;
	end

function FrameBuffer:getMaxUpscale()
    return MAX_UP_SCALE;
end

function FrameBuffer:getMaxDownscale()
    return MAX_DOWN_SCALE;
end

function FrameBuffer:getMaxRGBPipes()
    return MAX_RGB_PIPE;
end

function FrameBuffer:getMaxVIGPipes()
    return MAX_VIG_PIPE;
end

function FrameBuffer:getMaxDMAPipes()
    return MAX_DMA_PIPE;
end

function FrameBuffer:isBwcSupported()
    return IS_BWC_SUPPORTED;
end

function FrameBuffer:isDecimationSupported()
    return IS_DECIMATION_SUPPORTED;
end

function FrameBuffer:isTileFormatSupported()
    return IS_TILE_FORMAT_SUPPORTED;
end

function FrameBuffer:getSMPSize()
    return MAX_SMP_SIZE;
end

function FrameBuffer:getSMPCount()
    return MAX_SMP_COUNT;
end

-- setPpPaParam: Wrapper function for DSPP PA configuration using MSMFB_MDP_PP IOCTL
-- Inputs:
--      block : (MDP_LOGICAL_BLOCK_DISP_0/1/2)
--      enable : (PA Enable --> true / PA Disable --> false)
--      globalPadata : (display_pp_pa_cfg)
-- 		hue        - Hue, valid from -180.0 to 180.0 degrees
-- 		intensity  - Intensity, valid from 0 to 255
-- 		sat_thresh - threshold for saturation, valid from 0 - 255
-- 		sat        - Saturation, valid from -1.0 to 1.0 (percentage)
-- 		contrast   - Contrast, valid from -1.0 to 1.0 (percentage)

function FrameBuffer:setPpPaParam (block, enable, globalPadata)
	local pa_data = display_pp_pa_cfg();
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
	print("pa_data.ops", pa_data.ops);
	mdp_pp_pa(self.fb_handle, pa_data, block, MDP_REV);
end

-- Helper function to set Linear IGC curve
-- Inputs:
-- 	gcTable: IGC table of 256 element
-- 	startVal: Offset of IGC curver start
-- 	stepSize: Slope of IGC curve

function FrameBuffer:setLinearIgcCurve(gcTable, startVal, stepSize)
	local indx = 0;
	for indx = 1, MAX_IGC_LUT_ENTRIES, 1 do
		gcTable[indx] = startVal + (stepSize * indx);
	end
end

-- setPpIgcParam: Wrapper function for DSPP IGC Lut configuration using MSMFB_MDP_PP IOCTL
-- Inputs:
--      block (MDP_LOGICAL_BLOCK_DISP_0/1/2)
--      enable (PA Enable --> true / PA Disable --> false)
--      operation("read"/"write")
--      rVal (Table of size 256 For Red)
--      gVal (Table of size 256 For Green)
--      bVal (Table of size 256 For Blue)

function FrameBuffer:setPpIgcParam (block, enable, operation, rVal, gVal, bVal)
	local igcLut = display_pp_igc_lut_data();
	local ops = 0;
	if(enable == true) then
		ops = MDP_PP_OPS_ENABLE;
	else
		ops = MDP_PP_OPS_DISABLE;
	end
	if(operation == "read") then
		ops = bit32.bor(ops, MDP_PP_OPS_READ);
	elseif(operation == "write") then
		ops = bit32.bor(ops, MDP_PP_OPS_WRITE);
	end
	print("operation ",operation, " ops ", ops);

	local indx = 0;
	for indx = 1, MAX_IGC_LUT_ENTRIES, 1 do
		igcLut.c0[indx] = rVal[indx];
		igcLut.c1[indx] = gVal[indx];
		igcLut.c2[indx] = bVal[indx];
	end

	igcLut.ops = ops;
	print("operation ",operation, " igcLut.ops ", igcLut.ops);
	return mdp_pp_igc(self.fb_handle, igcLut, block);
end

function FrameBuffer:fillArgcTable(argcTable, argcVal);
	local indx = 0;

	for indx = 1, NUM_ARGC_STAGES , 1 do
		local cfg_data = display_pp_argc_stage_data();
		cfg_data.is_stage_enabled = argcVal[indx][1];
		cfg_data.x_start = argcVal[indx][2];
		cfg_data.slope = argcVal[indx][3];
		cfg_data.offset = argcVal[indx][4];
	        argcTable[indx] = cfg_data;
	end
end

function FrameBuffer:setPpArgcParam(block, enable, argcCfg)
	local ops = 0;
	if(enable == true) then
		ops = MDP_PP_OPS_ENABLE;
	else
		ops = MDP_PP_OPS_DISABLE;
	end

	ops = bit32.bor(ops, MDP_PP_OPS_WRITE);
	print("ops ", ops);

	local indx = 0;
	print("NUM_ARGC_STAGES ", NUM_ARGC_STAGES);

	argcCfg.ops = ops;
	print("argcCfg.ops ", argcCfg.ops);
	return mdp_pp_argc(self.fb_handle, argcCfg, block);
end


function FrameBuffer:setPpHistogramParam (block, enable, operation, rVal, gVal, bVal)
	local histcLut = pp_hist_lut_data();
	local ops = 0;
	if(enable == true) then
		ops = MDP_PP_OPS_ENABLE;
	else
		ops = MDP_PP_OPS_DISABLE;
	end
	if(operation == "read") then
		ops = bit32.bor(ops, MDP_PP_OPS_READ);
	elseif(operation == "write") then
		ops = bit32.bor(ops, MDP_PP_OPS_WRITE);
	end
	print("operation ",operation, " ops ", ops);

	local indx = 0;
	print("MAX_HIST_LUT_ENTRIES ", MAX_HIST_LUT_ENTRIES);

	for indx = 1, MAX_HIST_LUT_ENTRIES, 1 do
		print("indx ", indx);
		histcLut.r_data[indx] = rVal[indx];
		histcLut.g_data[indx] = gVal[indx];
		histcLut.b_data[indx] = bVal[indx];
	end

	histcLut.ops = ops;
	print("Operation ",operation, " histcLut.ops ", histcLut.ops);
	return mdp_pp_histogram(self.fb_handle, histcLut, block);
end

function round(num, idp)
	local mult = 10^(idp or 0)
	return math.floor(num * mult + 0.5) / mult
end

function FrameBuffer:setPpPccParam (block, enable, rCoff, gCoff, bCoff)
	local pcc_cfg = display_pp_pcc_cfg();
	local ops = 0;
	if(enable == true) then
		ops = MDP_PP_OPS_ENABLE;
	else
		ops = MDP_PP_OPS_DISABLE;
	end

	ops = bit32.bor(ops, MDP_PP_OPS_WRITE);
	pcc_cfg.ops = ops;
	pcc_cfg.r = rCoff;
	pcc_cfg.g = gCoff;
	pcc_cfg.b = bCoff;
	print("PCC Block ", block, " pcc.ops ", pcc_cfg.ops);
	return mdp_pp_pcc(self.fb_handle, pcc_cfg, block);
end

function FrameBuffer:fillPccCoff(coff)
	local pc_coff = display_pcc_coeff();
	local inxd = 0;
	if(coff ~= nil) then
		print("Set PCC Param");
		for indx = 1, PCC_COEFF_PER_COLOR , 1 do
			pc_coff.pcc_coeff[indx] = coff[indx];
		end
	else
		print("fillPccCoff is called with Nil value");
	end
	return pc_coff;
end

function FrameBuffer:setPpCscParam (block, enable, cscMv, cscPreBv, cscPostBv, cscPreLv, cscPostLv)
	local csc_cfg = mdp_csc_cfg();
	local ops = 0;
	if(enable == true) then
		ops = MDP_PP_OPS_ENABLE;
	else
		ops = MDP_PP_OPS_DISABLE;
	end
	ops = bit32.bor(ops, MDP_PP_OPS_WRITE);

	csc_cfg.flags = ops;
	csc_cfg.csc_mv = cscMv;
	csc_cfg.csc_pre_bv = cscPreBv;
	csc_cfg.csc_post_bv = cscPostBv;
	csc_cfg.csc_pre_lv = cscPreLv;
	csc_cfg.csc_post_lv = cscPostLv;

	print("CSC Block ",operation, " flags ", pcc_cfg.flags);
	return mdp_pp_csc(self.fb_handle, csc_cfg, block);
end

-- Function : setPpBlScaleParam
-- Helper to pass Backlight Scale Configuration data to PP IOCTL
-- blMinLevel :- Minimum Backlight
-- blMaxScaleFactor :- Maximum Backlight scale factor
-- Output : Success/Fail
function FrameBuffer:setPpBlScaleParam (blMinLevel, blMaxScaleFactor)
	local bl_scale_cfg = mdp_bl_scale_data();
	bl_scale_cfg.min_lvl = blMinLevel;
	bl_scale_cfg.scale = blMaxScaleFactor;
	return mdp_pp_bl_scale(self.fb_handle, bl_scale_cfg);
end

-- Function : setPpDitherParam
-- Helper to pass Dither Configuration data to PP IOCTL
-- block :- Logical Display ID (MDP_LOGICAL_BLOCK_DISP_0/MDP_LOGICAL_BLOCK_DISP_1/MDP_LOGICAL_BLOCK_DISP_2)
-- enable :- true - Enable Dither /false - Disable Dither
-- rBitdepth :- Red Bitdepth(0-8)
-- gBitdepth :- Gree Bitdepth(0-8)
-- bBitdepth :- Blue Bitdepth(0-8)
-- Output : Success/Fail
function FrameBuffer:setPpDitherParam (block, enable, rBitdepth, gBitdepth, bBitdepth)
	local dither_cfg = mdp_dither_cfg_data();
	local flags = 0;
	dither_cfg.block = block;
	if(enable == true) then
		flags = MDP_PP_OPS_ENABLE;
	else
		flags = MDP_PP_OPS_DISABLE;
	end
	flags = bit32.bor(flags, MDP_PP_OPS_WRITE);
	print("Dither block ", block, " flags ", flags);

	dither_cfg.flags = flags;
	dither_cfg.g_y_depth = gBitdepth;
	dither_cfg.r_cr_depth = rBitdepth;
	dither_cfg.b_cb_depth = bBitdepth;

	return mdp_pp_dither(self.fb_handle, dither_cfg);
end

-- Function : setGlobalPaParam
-- fillGammaLut :- Helper to populate "display_pp_pa_cfg"structure for PAV2 Global HSVI settings
-- hue :- hue(-180-180)
-- saturation :- saturation(0-1)
-- satThresh :- saturation threshold (0-255)
-- intensity :- intensity(0-255)
-- contrast :- contrast(0-1)
-- Return : display_pp_pa_cfg();
function FrameBuffer:setGlobalPaParam (hue, saturation, satThresh, intensity, contrast)
	local globalPadata = display_pp_pa_cfg();
	globalPadata.hue = hue;
	globalPadata.sat_thresh = satThresh;
	globalPadata.sat = saturation;
	globalPadata.intensity = intensity;
	globalPadata.contrast = contrast;
	print("setPav2GlobalPaParam");
	return globalPadata;
end

-- struct display_pp_mem_col_cfg - Structure for Memory Color adjustment data
-- offset - offset from minimum hue value to top corner of trapezoid (0.0 - 360.0)
-- hue_slope - floating point slope of trapezoid side for hue adjust, starting from hue min (-inf - inf)
-- sat_slope - floating point slope of trapezoid side for sat adjust, starting from hue min (-inf - inf)
-- val_slope - floating point slope of trapezoid side for val adjust, starting from hue min (-inf - inf)
-- hue_min - Min hue for memory color adjustments (0.0 - 360.0)
-- hue_max - Max hue for memory color adjustments (0.0 - 360.0)
-- sat_min - Min sat for memory color adjustments (0 - 1.0)
-- sat_max - Max sat for memory color adjustments (0 - 1.0)
-- val_min - Min val for memory color adjustments (0 - 255)
-- val_max - Max val for memory color adjustments (0 - 255)
-- Function : setPav2ColorParam
-- Helper to populate  "display_pp_mem_col_cfg"structure
-- param :- 10 element table
--          {offset, hue_slope, sat_slope, val_slope,
--          hue_min, hue_max, sat_min, sat_max, val_min, val_max}
-- Return : display_pp_mem_col_cfg();
function FrameBuffer:setPav2ColorParam (param)
	print("setPav2ColorParam");
	local color_cfg = display_pp_mem_col_cfg();
	color_cfg.offset = param[1];
	color_cfg.hue_slope = param[2];
	color_cfg.sat_slope = param[3];
	color_cfg.val_slope = param[4];
	color_cfg.hue_min = param[5];
	color_cfg.hue_max = param[6];
	color_cfg.sat_min = param[7];
	color_cfg.sat_max = param[8];
	color_cfg.val_min = param[9];
	color_cfg.val_max = param[10];
	print("setPav2ColorParam End");
	return  color_cfg;
end

-- Function : setPav2SixZoneParam
-- Helper to populate  "display_pp_six_zone_cfg"structure
-- threshold :- 3 element table {min saturation,  min value, max value}
--                            (0 - 1.0)   , (0 - 255), (0 - 255)
-- hueCurve :- 384 element table for Hue (-180.0 - 180.0)
-- satCurve :- 384 element table for Saturation (-1.0 - 1.0)
-- valCurve :- 384 element table for Value (-1.0 - 1.0)
-- Output : display_pp_six_zone_cfg();
function FrameBuffer:setPav2SixZoneParam (threshold, hueCurve, satCurve, valCurve);
	print("setPav2SixZoneParam start ");
	local zone_cfg = display_pp_six_zone_cfg();
	local indx = 0;
	zone_cfg.sat_min = threshold[1];
	zone_cfg.val_min = threshold[2];
	zone_cfg.val_max = threshold[3];
	if(hueCurve ~= nil) then
		for indx = 1, MDP_SIX_ZONE_LUT_SIZE , 1 do
			zone_cfg.hue[indx] = hueCurve[indx];
		end
	end
	if(satCurve ~= nil) then
		for indx = 1, MDP_SIX_ZONE_LUT_SIZE , 1 do
			zone_cfg.sat[indx] = satCurve[indx];
		end
	end
	if(valCurve ~= nil) then
		for indx = 1, MDP_SIX_ZONE_LUT_SIZE , 1 do
			zone_cfg.val[indx] = valCurve[indx];
		end
	end
	print("setPav2SixZoneParam End");
	return zone_cfg;
end

-- Function : setPpPav2Param
-- Helper to pass PAV2 Configuration data to PP IOCTL
-- block :- Logical Display ID (MDP_LOGICAL_BLOCK_DISP_0/MDP_LOGICAL_BLOCK_DISP_1/MDP_LOGICAL_BLOCK_DISP_2)
-- enable :- true - Enable Gamma Correction /false -disable Gamma Correction
-- skinCfg :- display_pp_mem_col_cfg() for skin
-- skyCfg :- display_pp_mem_col_cfg() for sky
-- folCfg :- display_pp_mem_col_cfg() for fol
-- globalPadata :- Global HSIC Parameters
-- sixZoneCfg :- display_pp_six_zone_cfg() for sixzone
-- Output : Success/Fail
function FrameBuffer:setPpPav2Param (block, enable, skinCfg, skyCfg, folCfg, globalPadata, sixZoneCfg)

	local flags = 0;
	pa_v2_cfg = display_pp_pa_v2_cfg();

	if(enable == true) then
		flags = MDP_PP_OPS_ENABLE;
	else
		flags = MDP_PP_OPS_DISABLE;
	end
	flags = bit32.bor(flags, MDP_PP_OPS_WRITE);
	pa_v2_cfg.ops = flags;

	if(skinCfg ~= nil) then
		pa_v2_cfg.skin_cfg = skinCfg;
		pa_v2_cfg.ops = bit32.bor(pa_v2_cfg.ops, MDP_PP_PA_MEM_COL_SKIN_MASK);
		pa_v2_cfg.ops = bit32.bor(pa_v2_cfg.ops, MDP_PP_PA_SKIN_ENABLE);
	end

	if(skyCfg ~= nil) then
		pa_v2_cfg.sky_cfg = skyCfg;
		pa_v2_cfg.ops = bit32.bor(pa_v2_cfg.ops, MDP_PP_PA_MEM_COL_SKY_MASK);
		pa_v2_cfg.ops = bit32.bor(pa_v2_cfg.ops, MDP_PP_PA_SKY_ENABLE);
	end

	if(folCfg ~= nil) then
		pa_v2_cfg.fol_cfg = folCfg;
		pa_v2_cfg.ops = bit32.bor(pa_v2_cfg.ops, MDP_PP_PA_MEM_COL_FOL_MASK);
		pa_v2_cfg.ops = bit32.bor(pa_v2_cfg.ops, MDP_PP_PA_FOL_ENABLE);
	end

	if(globalPadata ~= nil) then
		if (globalPadata.hue ~= nil) then
			pa_v2_cfg.global_hue = globalPadata.hue;
			pa_v2_cfg.ops = bit32.bor(pa_v2_cfg.ops, MDP_PP_PA_HUE_MASK);
			pa_v2_cfg.ops = bit32.bor(pa_v2_cfg.ops, MDP_PP_PA_HUE_ENABLE);
		end

		if (globalPadata.sat_thresh ~= nil) then
			pa_v2_cfg.ops = bit32.bor(pa_v2_cfg.ops, MDP_PP_PA_SAT_MASK);
			pa_v2_cfg.ops = bit32.bor(pa_v2_cfg.ops, MDP_PP_PA_SAT_ENABLE);
			pa_v2_cfg.sat_thresh = globalPadata.sat_thresh;
			pa_v2_cfg.global_saturation = globalPadata.sat;
		end

		if (globalPadata.intensity ~= nil) then
			pa_v2_cfg.ops = bit32.bor(pa_v2_cfg.ops, MDP_PP_PA_VAL_MASK);
			pa_v2_cfg.ops = bit32.bor(pa_v2_cfg.ops, MDP_PP_PA_VAL_ENABLE);
			pa_v2_cfg.global_value = globalPadata.intensity;
		end

		if (globalPadata.contrast ~= nil) then
			pa_v2_cfg.ops = bit32.bor(pa_v2_cfg.ops, MDP_PP_PA_CONT_MASK);
			pa_v2_cfg.ops = bit32.bor(pa_v2_cfg.ops, MDP_PP_PA_CONT_ENABLE);
			pa_v2_cfg.global_contrast = globalPadata.contrast;
		end
	end
	if(sixZoneCfg ~= nil) then
		pa_v2_cfg.six_zone_cfg = sixZoneCfg;
		pa_v2_cfg.ops = bit32.bor(pa_v2_cfg.ops, MDP_PP_PA_SIX_ZONE_ENABLE);
		pa_v2_cfg.ops = bit32.bor(pa_v2_cfg.ops, MDP_PP_PA_SIX_ZONE_HUE_MASK);
		pa_v2_cfg.ops = bit32.bor(pa_v2_cfg.ops, MDP_PP_PA_SIX_ZONE_SAT_MASK);
		pa_v2_cfg.ops = bit32.bor(pa_v2_cfg.ops, MDP_PP_PA_SIX_ZONE_VAL_MASK);
	end
	print("setPpPav2Param Start");

	print("setPpPav2Param END");
	return mdp_pp_pav2(self.fb_handle, pa_v2_cfg, block);
end

-- Function : fillGamut
-- Helper to fill Gamma Tables for a color
-- c0 :- 125 Element for C0
-- c1 :- 100 Element for C1
-- c2 :- 80 Element for C2
-- c3 :- 100 Element for C3
-- c4 :- 100 Element for C4
-- c5 :- 80 Element for C5
-- c6 :- 64 Element for C6
-- c7 :- 80 Element for C7
-- Output : variable of type "gamut_tbl()"
function FrameBuffer:fillGamut (c0,c1,c2,c3,c4,c5,c6,c7)
	local gammaTable = gamut_tbl();
	print("fillGamut Start");
	if(c0 ~= nill) then
		print("fillGamut C0");
		for count = 1, GAMUT_T0_SIZE, 1 do
			gammaTable.c0[count] = c0[count];
		end
	end
	if(c1 ~= nill) then
		print("fillGamut C1");
		for count = 1, GAMUT_T1_SIZE, 1 do
			gammaTable.c1[count] = c1[count];
		end
	end
	if(c2 ~= nill) then
		print("fillGamut C2");
		for count = 1, GAMUT_T2_SIZE, 1 do
			gammaTable.c2[count] = c2[count];
		end
	end
	if(c3 ~= nill) then
		print("fillGamut C3");
		for count = 1, GAMUT_T3_SIZE, 1 do
			gammaTable.c3[count] = c3[count];
		end
	end
	if(c4 ~= nill) then
		print("fillGamut C4");
		for count = 1, GAMUT_T4_SIZE, 1 do
			gammaTable.c4[count] = c4[count];
		end
	end
	if(c5 ~= nill) then
		print("fillGamut C5");
		for count = 1, GAMUT_T5_SIZE, 1 do
			gammaTable.c5[count] = c5[count];
		end
	end
	if(c6 ~= nill) then
		print("fillGamut C6");
		for count = 1, GAMUT_T6_SIZE, 1 do
			gammaTable.c6[count] = c6[count];
		end
	end
	if(c7 ~= nill) then
		print("fillGamut C7");
		for count = 1, GAMUT_T7_SIZE, 1 do
			gammaTable.c7[count] = c7[count];
		end
	end
	return gammaTable;
end

-- Function : setPpGamutParam
-- Helper to pass Gamma Tables to PP IOCTL
-- block :- Logical Display ID ID (MDP_LOGICAL_BLOCK_DISP_0/MDP_LOGICAL_BLOCK_DISP_1/MDP_LOGICAL_BLOCK_DISP_2)
-- enable :- true - Enable Gamma Correction /false -disable Gamma Correction
-- redGamut :- local variable of type "gamut_tbl() for Red"
-- greenGamut :- local variable of type "gamut_tbl() for Blue"
-- blueGamut :- local variable of type "gamut_tbl() for Green"
-- Output : Success/Fail
function FrameBuffer:setPpGamutParam (block, enable, redGamut, greenGamut, blueGamut)
	local flags = 0;

	if(enable == true) then
		flags = MDP_PP_OPS_ENABLE;
	else
		flags = MDP_PP_OPS_DISABLE;
	end
	flags = bit32.bor(flags, MDP_PP_OPS_WRITE);
	return mdp_pp_gamut(self.fb_handle, redGamut, greenGamut, blueGamut, block, flags, 1);
end

-- Function : fillGammaLut
-- Helper to populate Gamma Table using Ramp
-- gammaTable :- local variable of type "gamut_tbl()"
-- gammaTableZise :- Gamma Table Size
-- startVal :- Ramp Start Value
-- stepSize : Ramp Step Size
-- Output : Nil
function FrameBuffer:fillGammaLut(gammaTable, gammaTableZise, startVal, stepSize)
	local indx = 0;
	for indx = 1, gammaTableZise, 1 do
		gammaTable[indx] = startVal + (stepSize * indx);
	end
end

-- Function : cabl_cfg
-- Helper to Enable/Disable CABL using PP Daemon
-- enable :- true CABL Enable/ false CABLE Disable
-- Output : Nil
function FrameBuffer:cabl_cfg(enable)
	return cabl_cfg(enable);
end

-- Function : ad_cfg
-- Helper to Enable/Disable Assertive Display using PP Daemon
-- enable :- true AD Enable/ false AD Disable
-- Output : Nil
function FrameBuffer:ad_cfg(enable)
	return ad_cfg(enable);
end

-- Function : svi_cfg
-- Helper to Enable/Disable SVI using PP Daemon
-- enable :- true SVI Enable/ false SVI Disable
-- Output : Nil
function FrameBuffer:svi_cfg(enable)
	return svi_cfg(enable);
end

-- Function : dcm_cfg
-- Helper to Enable/Disable DCM using PP Daemon
-- enable :- true DCM Enable/ false DCM Disable
-- Output : Nil
function FrameBuffer:dcm_cfg(enable)
	return dcm_cfg(enable);
end

-- Function : pp_cfg
-- Helper to Enable/Disable PP using PP Daemon
-- enable :- true PP Enable/ false PP Disable
-- Output : Nil
function FrameBuffer:pp_cfg(enable)
	return pp_cfg(enable);
end

-- Call get_fb_fix_screeninfo
function FrameBuffer:getFbHandle()
	-- print("FrameBuffer:getFbVarScreenInfo");
	return self.fb_handle;
end


-- Generic Commit Helper function
function set_play_commit(ov, fb)
	if((IS_RGB_SCALING_SUPPORTED == false) and (ov:getId() > math.pow(2, MAX_VIG_PIPE)) and
	(ov:getId() < 4294967295) and ((ov:getSrcRectWidth() ~= ov:getDstRectWidth()) or
	(ov:getSrcRectHeight() ~= ov:getDstRectHeight()))) then
		ov:unsetOverlay();
		print("RGB_SCALING_SUPPORTED ", IS_RGB_SCALING_SUPPORTED, "Unset RGB Overlay Id ", ov:getId());
		if(fb:displayCommit() ~= 0) then
			print("commit failed");
			return -1;
		end
		ov:setFlags(bit32.bxor(ov:getFlags(), MDP_OV_PIPE_SHARE));
	end
	if((IS_RGB_SCALING_SUPPORTED == false) and (ov:getId() == 4294967295) and
	((ov:getSrcRectWidth() ~= ov:getDstRectWidth()) or
	(ov:getSrcRectHeight() ~= ov:getDstRectHeight()))) then
		ov:setFlags(bit32.bxor(ov:getFlags(), MDP_OV_PIPE_SHARE));
	end
	local setResult = ov:setOverlay();
	if((setResult ~= 0))then
		if ((setResult ~= -7) or (setResult ~= -75) or (setResult ~= -1)) then
			if ((setResult ~= -7) or (setResult ~= -75)) then
				print("SetOverlay failure ignored for messages: ", setResult);
				return -2;
			else
				print("setOverlay failed : ", setResult);
				return -1;
			end
		end
	end

	if((string.find(string.lower(tostring(fb["fb_type"])), "writeback")))  then
		print("FBType is Writeback");
		if(fb:queue_buffer() ~= 0) then
			print("WB -> queue_buffer : failed\n");
			return -1;
		end
		print("WB -> queue_buffer : Success");
	end

	if(ov:playOverlay() ~=0) then
		print("SPC -> playOverlay : failed\n");
		return -1;
	end

	if(fb:displayCommit() ~= 0) then
		print("SPC -> commit : failed\n");
		if((string.find(string.lower(tostring(fb["fb_type"])), "writeback")))  then
			if(fb:dequeue_buffer(true) ~= 0) then
				print("WB -> dequeue_buffer : failed\n");
				return -1;
			end
		end
		return -1;
	end

	if((string.find(string.lower(tostring(fb["fb_type"])), "writeback")))  then
		print("FBType is Writeback");
		if(fb:dequeue_buffer(true) ~= 0) then
			print("WB -> dequeue_buffer : failed\n");
			return -1;
		end
		print("WB -> dequeue_buffer : Success");
	end
end

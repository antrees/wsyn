-- w/syn params script

item_nbr = 1
optid = 'wsyn_curve'

optid_tbl = {
    'wsyn_curve',
    'wsyn_ramp',
    'wsyn_fm_index',
    'wsyn_fm_env',
    'wsyn_fm_ratio_num',
    'wsyn_fm_ratio_den',
    'wsyn_lpg_time',
    'wsyn_lpg_symmetry',
    'wsyn_patch_this',
    'wsyn_patch_that',
}

function wsyn_add_params() 
    params:add_group("w/syn1",12)
    params:add {
        type = "option",
        id = "wsyn_ar_mode",
        name = "AR mode",
        options = {"off", "on"},
        default = 2,
        action = function(val) 
        crow.send("ii.wsyn.ar_mode(".. (val-1) ..")")
        end
    }
    params:add {
        type = "control",
        id = "wsyn_velocity",
        name = "Velocity",
        controlspec = controlspec.new(0, 5, "lin", 0, 2, "v"),
        action = function(val) 
        pset_wsyn_vel = val
        end
    }
    params:add {
        type = "control",
        id = "wsyn_curve",
        name = "Curve",
        controlspec = controlspec.new(-5, 5, "lin", 0.01, 5, "v",0.001),
        action = function(val) 
        crow.send("ii.wsyn.curve(" .. val .. ")") 
        pset_wsyn_curve = val
        end
    }
    params:add {
        type = "control",
        id = "wsyn_ramp",
        name = "Ramp",
        controlspec = controlspec.new(-5, 5, "lin", 0.01, 0, "v",0.001),
        action = function(val) 
        crow.send("ii.wsyn.ramp(" .. val .. ")") 
        pset_wsyn_ramp = val
        end
    }
    params:add {
        type = "control",
        id = "wsyn_fm_index",
        name = "FM index",
        controlspec = controlspec.new(-5, 5, "lin", 0.01, 0, "v",0.001),
        action = function(val) 
        crow.send("ii.wsyn.fm_index(" .. val .. ")") 
        pset_wsyn_fm_index = val
        end
    }
    params:add {
        type = "control",
        id = "wsyn_fm_env",
        name = "FM env",
        controlspec = controlspec.new(-5, 5, "lin", 0.01, 0, "v",0.001),
        action = function(val) 
        crow.send("ii.wsyn.fm_env(" .. val .. ")") 
        pset_wsyn_fm_env = val
        end
    }
    params:add {
        type = "control",
        id = "wsyn_fm_ratio_num",
        name = "FM ratio numerator",
        controlspec = controlspec.new(1, 20, "lin", 1, 2),
        action = function(val) 
        crow.send("ii.wsyn.fm_ratio(" .. val .. "," .. params:get("wsyn_fm_ratio_den") .. ")") 
        pset_wsyn_fm_ratio_num = val
        end
    }

    params:add {
        type = "control",
        id = "wsyn_fm_ratio_den",
        name = "FM ratio denominator",
        controlspec = controlspec.new(1, 20, "lin", 1, 1),
        action = function(val) 
        crow.send("ii.wsyn.fm_ratio(" .. params:get("wsyn_fm_ratio_num") .. "," .. val .. ")") 
        pset_wsyn_fm_ratio_den = val
        end
    }
    params:add {
        type = "control",
        id = "wsyn_lpg_time",
        name = "LPG time",
        controlspec = controlspec.new(-5, 5, "lin", 0.01, -2.3, "v",0.001),
        action = function(val) 
        crow.send("ii.wsyn.lpg_time(" .. val .. ")") 
        pset_wsyn_lpg_time = val
        end
    }
    params:add {
        type = "control",
        id = "wsyn_lpg_symmetry",
        name = "LPG symmetry",
        controlspec = controlspec.new(-5, 5, "lin", 0.01, -4.9, "v",0.001),
        action = function(val) 
        crow.send("ii.wsyn.lpg_symmetry(" .. val .. ")") 
        pset_wsyn_lpg_symmetry = val
        end
    }
    params:add{
        type = 'option',
        id = 'wsyn_patch_this',
        name = 'patch this',
        options = {
          'ramp', 'curve', 'fm env', 'fm index', 'lpg_time', 'lpg_symmetry', 'gate',
          'pitch', 'fm num ratio', 'fm denum ratio',
        },
        default = 1,
        action = function(val)
          crow.send("ii.wsyn.patch(1 ," .. val .. ")")
        end
    }
    params:add{
        type = 'option',
        id = 'wsyn_patch_that',
        name = 'patch that',
        options = {
            'ramp', 'curve', 'fm env', 'fm index', 'lpg time', 'lpg symmetry', 'gate',
            'pitch', 'fm num ratio', 'fm denum ratio',
        },
        default = 2,
        action = function(val)
            crow.send("ii.wsyn.patch(2 ," .. val .. ")")
        end
    }
end

function init()
  crow.send("ii.wsyn.ar_mode(1)")
  wsyn_add_params()
end

function enc(n, d)
  if n == 2 then
    item_nbr = util.clamp(item_nbr+d,1,#optid_tbl)
    optid = optid_tbl[item_nbr]
  elseif n == 3 then
    if optid == 'wsyn_curve' then
        params:delta("wsyn_curve",d)
    elseif optid == 'wsyn_ramp' then
        params:delta("wsyn_ramp",d)
    elseif optid == 'wsyn_fm_index' then
        params:delta("wsyn_fm_index",d)
    elseif optid == 'wsyn_fm_env' then
        params:delta("wsyn_fm_env",d)
    elseif optid == 'wsyn_fm_ratio_num' then
        params:delta("wsyn_fm_ratio_num",d)
    elseif optid == 'wsyn_fm_ratio_den' then
        params:delta("wsyn_fm_ratio_den",d)
    elseif optid == 'wsyn_lpg_time' then
        params:delta("wsyn_lpg_time",d)
    elseif optid == 'wsyn_lpg_symmetry' then
        params:delta("wsyn_lpg_symmetry",d)
    elseif optid == 'wsyn_patch_this' then
        params:delta("wsyn_patch_this",d)
    elseif optid == 'wsyn_patch_that' then
        params:delta("wsyn_patch_that",d)
    end
  end
  redraw()
end
  
function redraw()

  screen.clear()
  screen.aa(1)
  screen.font_face(1)
  screen.font_size(8) 

  screen.level(optid == 'wsyn_curve' and 15 or 1)
  screen.move(0,10)
  screen.text("curve")
  screen.move(45,10)
  screen.text(params:get('wsyn_curve'))

  screen.level(optid == 'wsyn_ramp' and 15 or 1)
  screen.move(0,20)
  screen.text("ramp")
  screen.move(45,20)
  screen.text(params:get('wsyn_ramp'))

  screen.level(optid == 'wsyn_fm_index' and 15 or 1)
  screen.move(0,30)
  screen.text("fm index")
  screen.move(45,30)
  screen.text(params:get('wsyn_fm_index'))

  screen.level(optid == 'wsyn_fm_env' and 15 or 1)
  screen.move(0,40)
  screen.text("env")
  screen.move(45,40)
  screen.text(params:get('wsyn_fm_env'))

  screen.level(optid == 'wsyn_fm_ratio_num' and 15 or 1)
  screen.move(0,50)
  screen.text("ratio num")
  screen.move(45,50)
  screen.text(params:get('wsyn_fm_ratio_num'))

  screen.level(optid == 'wsyn_fm_ratio_den' and 15 or 1)
  screen.move(0,60)
  screen.text("ratio den")
  screen.move(45,60)
  screen.text(params:get('wsyn_fm_ratio_den'))

  screen.level(optid == 'wsyn_lpg_time' and 15 or 1)
  screen.move(65,10)
  screen.text("lpg time")
  screen.move(105,10)
  screen.text(params:get('wsyn_lpg_time'))

  screen.level(optid == 'wsyn_lpg_symmetry' and 15 or 1)
  screen.move(65,20)
  screen.text("lpg sym")
  screen.move(105,20)
  screen.text(params:get('wsyn_lpg_symmetry'))

  screen.level(optid == 'wsyn_patch_this' and 15 or 1)
  screen.move(65,30)
  screen.text("this")
  screen.move(90,30)
  screen.text(params:string('wsyn_patch_this'))

  screen.level(optid == 'wsyn_patch_that' and 15 or 1)
  screen.move(65,40)
  screen.text("that")
  screen.move(90,40)
  screen.text(params:string('wsyn_patch_that'))

  screen.update()
end

# PlanAhead Launch Script for Post-Synthesis pin planning, created by Project Navigator

create_project -name work55 -dir "E:/work55/work55/planAhead_run_3" -part xc3s1200efg320-4
set_property design_mode GateLvl [get_property srcset [current_run -impl]]
set_property edif_top_file "E:/work55/work55/CK.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {E:/work55/work55} }
set_param project.pinAheadLayout  yes
set_property target_constrs_file "CK.ucf" [current_fileset -constrset]
add_files [list {CK.ucf}] -fileset [get_property constrset [current_run]]
link_design

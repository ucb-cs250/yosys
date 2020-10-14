
OBJS += techlibs/borca/synth_borca.o

$(eval $(call add_share_file,share/borca/,techlibs/borca/arith_map.v))
$(eval $(call add_share_file,share/borca/,techlibs/borca/cells_sim.v))
$(eval $(call add_share_file,share/borca/,techlibs/borca/cells_map.v))

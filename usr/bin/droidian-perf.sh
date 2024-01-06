#!/bin/bash

CORE_FIRST=$(awk '$1 == "processor" {print $3; exit}' /proc/cpuinfo)
CORE_LAST=$(awk '$1 == "processor" {print $3}' /proc/cpuinfo | tail -1)

for ((i=$CORE_FIRST; i<=$CORE_LAST; i++))
do
   MAXFREQ=$(cat /sys/devices/system/cpu/cpu${i}/cpufreq/scaling_available_frequencies | awk '{print $NF}')
   if [ -f "/var/lib/batman/default_cpu_governor" ]; then
      GOVERNOR=$(</var/lib/batman/default_cpu_governor)
   else
      GOVERNOR=$(</sys/devices/system/cpu/cpu${i}/cpufreq/scaling_governor)
   fi

   if [ -f "/sys/devices/system/cpu/cpu${i}/sched_load_boost" ]; then
       echo -6 > /sys/devices/system/cpu/cpu${i}/sched_load_boost
       echo -n "/sys/devices/system/cpu/cpu${i}/sched_load_boost "
       cat /sys/devices/system/cpu/cpu${i}/sched_load_boost
   fi

   if [ -d "/sys/devices/system/cpu/cpu${i}/cpufreq/$GOVERNOR" ]; then
      if [ -f "/sys/devices/system/cpu/cpu${i}/cpufreq/${GOVERNOR}/hispeed_freq" ]; then
         echo "$MAXFREQ" > /sys/devices/system/cpu/cpu${i}/cpufreq/${GOVERNOR}/hispeed_freq
         echo -n "/sys/devices/system/cpu/cpu${i}/cpufreq/${GOVERNOR}/hispeed_freq "
         echo "$MAXFREQ"
      fi
   fi
done

mkdir -p /sys/fs/cgroup/schedtune

mount -t cgroup -o schedtune stune /sys/fs/cgroup/schedtune # needs schedtune in kernel

[ -f /sys/fs/cgroup/schedtune/schedtune.boost ] && echo 20 > /sys/fs/cgroup/schedtune/schedtune.boost # needs schedtune in kernel
[ -f /sys/fs/cgroup/schedtune/schedtune.prefer_idle ] && echo 1 > /sys/fs/cgroup/schedtune/schedtune.prefer_idle # needs schedtune in kernel

[ -f /sys/module/ged/parameters/ged_monitor_3D_fence_disable ] && echo 1 > /sys/module/ged/parameters/ged_monitor_3D_fence_disable # spotted on mt6769v
[ -f /proc/sys/kernel/sched_autogroup_enabled ] && echo 0 > /proc/sys/kernel/sched_autogroup_enabled # spotted on sm7125 and msm8996 and sdm670
[ -f /sys/class/kgsl/kgsl-3d0/bus_split ] && echo 0 > /sys/class/kgsl/kgsl-3d0/bus_split # spotted on sm7125 and msm8996 and sdm670
[ -f /sys/class/kgsl/kgsl-3d0/force_no_nap ] && echo 0 > /sys/class/kgsl/kgsl-3d0/force_no_nap # spotted on sm7125 and msm8996 and sdm670
[ -f /sys/class/kgsl/kgsl-3d0/force_bus_on ] && echo 0 > /sys/class/kgsl/kgsl-3d0/force_bus_on # spotted on sm7125 and msm8996 and sdm670
[ -f /sys/class/kgsl/kgsl-3d0/force_clk_on ] && echo 0 > /sys/class/kgsl/kgsl-3d0/force_clk_on # spotted on sm7125 and msm8996 and sdm670
[ -f /sys/class/kgsl/kgsl-3d0/force_rail_on ] && echo 0 > /sys/class/kgsl/kgsl-3d0/force_rail_on # spotted on sm7125 and msm8996 and sdm670
[ -f /sys/class/kgsl/kgsl-3d0/popp ] && echo 0 > /sys/class/kgsl/kgsl-3d0/popp # spotted on sm7125 and msm8996 and sdm670
[ -f /sys/class/kgsl/kgsl-3d0/pwrnap ] && echo 0 > /sys/class/kgsl/kgsl-3d0/pwrnap # spotted on sm7125 and msm8996 and sdm670
[ -f /proc/sys/kernel/sched_child_runs_first ] && echo 0 > /proc/sys/kernel/sched_child_runs_first # spotted on sm7125 and msm8996 and sdm670
[ -f /proc/sys/kernel/perf_cpu_time_max_percent ] && echo 20 > /proc/sys/kernel/perf_cpu_time_max_percent # spotted on sm7125 and msm8996 and sdm670
[ -f /proc/sys/kernel/sched_tunable_scaling ] && echo 0 > /proc/sys/kernel/sched_tunable_scaling # spotted on sm7125 and msm8996 and sdm670
[ -f /proc/sys/kernel/sched_migration_cost_ns ] && echo 0 > /proc/sys/kernel/sched_migration_cost_ns # spotted on sm7125 and msm8996 and sdm670
[ -f /proc/perfmgr/boost_ctrl/eas_ctrl/m_sched_migrate_cost_n ] && echo 0 > /proc/perfmgr/boost_ctrl/eas_ctrl/m_sched_migrate_cost_n # spotted on sdm845
[ -f /proc/sys/kernel/sched_min_task_util_for_colocation ] && echo 0 > /proc/sys/kernel/sched_min_task_util_for_colocation # spotted on sdm845
[ -f /proc/sys/kernel/sched_min_task_util_for_boost ] && echo 0 > /proc/sys/kernel/sched_min_task_util_for_boost # spotted on sm7125
[ -f /proc/sys/kernel/sched_nr_migrate ] && echo 128 > /proc/sys/kernel/sched_nr_migrate # spotted on sm7125 and msm8996 and sdm670
[ -f /proc/sys/kernel/sched_schedstats ] && echo 0 > /proc/sys/kernel/sched_schedstats # spotted on sm7125 and sdm670
[ -f /proc/sys/kernel/sched_cstate_aware ] && echo 1 > /proc/sys/kernel/sched_cstate_aware # spotted on sm7125 and sdm670
[ -f /proc/sys/kernel/timer_migration ] && echo 0 > /proc/sys/kernel/timer_migration # spotted on sm7125 and msm8996 and sdm670
[ -f /proc/sys/kernel/sched_boost ] && echo 1 > /proc/sys/kernel/sched_boost # spotted on sm7125 and msm8996 and sdm670
[ -f /sys/devices/system/cpu/eas/enable ] && echo 0 > /sys/devices/system/cpu/eas/enable # spotted on sm7125
[ -f /proc/sys/kernel/sched_walt_rotate_big_tasks ] && echo 1 > /proc/sys/kernel/sched_walt_rotate_big_tasks # spotted on sdm845 and sdm670
[ -f /proc/sys/kernel/sched_prefer_sync_wakee_to_waker ] && echo 1 > /proc/sys/kernel/sched_prefer_sync_wakee_to_waker # spotted on sm7125 and msm8996
[ -f /proc/sys/kernel/sched_boost_top_app ] && echo 1 > /proc/sys/kernel/sched_boost_top_app # spotted on sm7125
[ -f /proc/sys/kernel/sched_init_task_load ] && echo 30 > /proc/sys/kernel/sched_init_task_load # spotted on sm7125 and msm8996
[ -f /proc/sys/kernel/sched_migration_fixup ] && echo 0 > /proc/sys/kernel/sched_migration_fixup # spotted on sm7125
[ -f /proc/sys/kernel/sched_energy_aware ] && echo 0 > /proc/sys/kernel/sched_energy_aware # spotted on sm7125
[ -f /proc/sys/kernel/hung_task_timeout_secs ] && echo 0 > /proc/sys/kernel/hung_task_timeout_secs # spotted on sm7125 and msm8996 and sdm670
[ -f /proc/sys/kernel/sched_conservative_pl ] && echo 0 > /proc/sys/kernel/sched_conservative_pl # spotted on sm7125 and msm8996
[ -f /sys/kernel/debug/debug_enabled ] && echo 0 > /sys/kernel/debug/debug_enabled # spotted on msm8996 and sdm670
[ -f /sys/kernel/debug/msm_vidc/fw_debug_mode ] && echo 0 > /sys/kernel/debug/msm_vidc/fw_debug_mode # spotted on sm7125 and msm8996 and sdm670
[ -f /sys/module/cryptomgr/parameters/notests ] && echo Y > /sys/module/cryptomgr/parameters/notests # spotted on sm7125 and sdm670
[ -f /proc/sys/dev/tty/ldisc_autoload ] && echo 0 > /proc/sys/dev/tty/ldisc_autoload # spotted on sm7125
[ -f /sys/kernel/rcu_normal ] && echo 1 > /sys/kernel/rcu_normal # spotted on sm7125 and sdm670
[ -f /sys/kernel/rcu_expedited ] && echo 0 > /sys/kernel/rcu_expedited # spotted on sm7125 and msm8996 and sdm670
[ -f /sys/module/spurious/parameters/noirqdebug ] && echo 1 > /sys/module/spurious/parameters/noirqdebug # spotted on sm7125 and msm8996 and sdm670

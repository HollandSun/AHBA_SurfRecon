

#---------------------------------
# New invocation of recon-all Wed Dec 13 21:55:20 UTC 2023 
#--------------------------------------------
#@# Tessellate lh Wed Dec 13 21:55:23 UTC 2023

 mri_pretess ../mri/filled.mgz 255 ../mri/norm.mgz ../mri/filled-pretess255.mgz 


 mri_tessellate ../mri/filled-pretess255.mgz 255 ../surf/lh.orig.nofix 


 rm -f ../mri/filled-pretess255.mgz 


 mris_extract_main_component ../surf/lh.orig.nofix ../surf/lh.orig.nofix 

#--------------------------------------------
#@# Smooth1 lh Wed Dec 13 21:55:26 UTC 2023

 mris_smooth -nw -seed 1234 ../surf/lh.orig.nofix ../surf/lh.smoothwm.nofix 

#--------------------------------------------
#@# Inflation1 lh Wed Dec 13 21:55:28 UTC 2023

 mris_inflate -no-save-sulc ../surf/lh.smoothwm.nofix ../surf/lh.inflated.nofix 

#--------------------------------------------
#@# QSphere lh Wed Dec 13 21:55:32 UTC 2023

 mris_sphere -q -p 6 -a 128 -seed 1234 ../surf/lh.inflated.nofix ../surf/lh.qsphere.nofix 

#@# Fix Topology lh Wed Dec 13 21:55:57 UTC 2023

 mris_fix_topology -mgz -sphere qsphere.nofix -inflated inflated.nofix -orig orig.nofix -out orig.premesh -ga -seed 1234 sub-2002 lh 


 mris_euler_number ../surf/lh.orig.premesh 


 mris_remesh --remesh --iters 3 --input /output/sourcedata/freesurfer/sub-2002/surf/lh.orig.premesh --output /output/sourcedata/freesurfer/sub-2002/surf/lh.orig 


 mris_remove_intersection ../surf/lh.orig ../surf/lh.orig 


 rm -f ../surf/lh.inflated 

#--------------------------------------------
#@# AutoDetGWStats lh Wed Dec 13 22:01:27 UTC 2023
cd /output/sourcedata/freesurfer/sub-2002/mri
mris_autodet_gwstats --o ../surf/autodet.gw.stats.lh.dat --i brain.finalsurfs.mgz --wm wm.mgz --surf ../surf/lh.orig.premesh
#--------------------------------------------
#@# WhitePreAparc lh Wed Dec 13 22:01:29 UTC 2023
cd /output/sourcedata/freesurfer/sub-2002/mri
mris_place_surface --adgws-in ../surf/autodet.gw.stats.lh.dat --wm wm.mgz --threads 8 --invol brain.finalsurfs.mgz --lh --i ../surf/lh.orig --o ../surf/lh.white.preaparc --white --seg aseg.presurf.mgz --nsmooth 5
#--------------------------------------------
#@# CortexLabel lh Wed Dec 13 22:02:58 UTC 2023
cd /output/sourcedata/freesurfer/sub-2002/mri
mri_label2label --label-cortex ../surf/lh.white.preaparc aseg.presurf.mgz 0 ../label/lh.cortex.label
#--------------------------------------------
#@# CortexLabel+HipAmyg lh Wed Dec 13 22:03:05 UTC 2023
cd /output/sourcedata/freesurfer/sub-2002/mri
mri_label2label --label-cortex ../surf/lh.white.preaparc aseg.presurf.mgz 1 ../label/lh.cortex+hipamyg.label
#--------------------------------------------
#@# Smooth2 lh Wed Dec 13 22:03:11 UTC 2023

 mris_smooth -n 3 -nw -seed 1234 ../surf/lh.white.preaparc ../surf/lh.smoothwm 

#--------------------------------------------
#@# Inflation2 lh Wed Dec 13 22:03:13 UTC 2023

 mris_inflate ../surf/lh.smoothwm ../surf/lh.inflated 

#--------------------------------------------
#@# Curv .H and .K lh Wed Dec 13 22:03:18 UTC 2023

 mris_curvature -w -seed 1234 lh.white.preaparc 


 mris_curvature -seed 1234 -thresh .999 -n -a 5 -w -distances 10 10 lh.inflated 

#--------------------------------------------
#@# Sphere lh Wed Dec 13 22:03:42 UTC 2023

 mris_sphere -seed 1234 ../surf/lh.inflated ../surf/lh.sphere 

#--------------------------------------------
#@# Surf Reg lh Wed Dec 13 22:05:05 UTC 2023

 mris_register -curv ../surf/lh.sphere /opt/freesurfer/average/lh.folding.atlas.acfb40.noaparc.i12.2016-08-02.tif ../surf/lh.sphere.reg 


 ln -sf lh.sphere.reg lh.fsaverage.sphere.reg 

#--------------------------------------------
#@# Jacobian white lh Wed Dec 13 22:06:28 UTC 2023

 mris_jacobian ../surf/lh.white.preaparc ../surf/lh.sphere.reg ../surf/lh.jacobian_white 

#--------------------------------------------
#@# AvgCurv lh Wed Dec 13 22:06:29 UTC 2023

 mrisp_paint -a 5 /opt/freesurfer/average/lh.folding.atlas.acfb40.noaparc.i12.2016-08-02.tif#6 ../surf/lh.sphere.reg ../surf/lh.avg_curv 

#-----------------------------------------
#@# Cortical Parc lh Wed Dec 13 22:06:29 UTC 2023

 mris_ca_label -l ../label/lh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 sub-2002 lh ../surf/lh.sphere.reg /opt/freesurfer/average/lh.DKaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/lh.aparc.annot 

#--------------------------------------------
#@# WhiteSurfs lh Wed Dec 13 22:06:35 UTC 2023
cd /output/sourcedata/freesurfer/sub-2002/mri
mris_place_surface --adgws-in ../surf/autodet.gw.stats.lh.dat --seg aseg.presurf.mgz --threads 8 --wm wm.mgz --invol brain.finalsurfs.mgz --lh --i ../surf/lh.white.preaparc --o ../surf/lh.white --white --nsmooth 0 --rip-label ../label/lh.cortex.label --rip-bg --rip-surf ../surf/lh.white.preaparc --aparc ../label/lh.aparc.annot
#--------------------------------------------
#@# T1PialSurf lh Wed Dec 13 22:07:55 UTC 2023
cd /output/sourcedata/freesurfer/sub-2002/mri
mris_place_surface --adgws-in ../surf/autodet.gw.stats.lh.dat --seg aseg.presurf.mgz --threads 8 --wm wm.mgz --invol brain.finalsurfs.mgz --lh --i ../surf/lh.white --o ../surf/lh.pial.T1 --pial --nsmooth 0 --rip-label ../label/lh.cortex+hipamyg.label --pin-medial-wall ../label/lh.cortex.label --aparc ../label/lh.aparc.annot --repulse-surf ../surf/lh.white --white-surf ../surf/lh.white
#@# white curv lh Wed Dec 13 22:09:14 UTC 2023
cd /output/sourcedata/freesurfer/sub-2002/mri
mris_place_surface --curv-map ../surf/lh.white 2 10 ../surf/lh.curv
#@# white area lh Wed Dec 13 22:09:15 UTC 2023
cd /output/sourcedata/freesurfer/sub-2002/mri
mris_place_surface --area-map ../surf/lh.white ../surf/lh.area
#@# pial curv lh Wed Dec 13 22:09:15 UTC 2023
cd /output/sourcedata/freesurfer/sub-2002/mri
mris_place_surface --curv-map ../surf/lh.pial 2 10 ../surf/lh.curv.pial
#@# pial area lh Wed Dec 13 22:09:16 UTC 2023
cd /output/sourcedata/freesurfer/sub-2002/mri
mris_place_surface --area-map ../surf/lh.pial ../surf/lh.area.pial
#@# thickness lh Wed Dec 13 22:09:17 UTC 2023
cd /output/sourcedata/freesurfer/sub-2002/mri
mris_place_surface --thickness ../surf/lh.white ../surf/lh.pial 20 5 ../surf/lh.thickness
#@# area and vertex vol lh Wed Dec 13 22:09:29 UTC 2023
cd /output/sourcedata/freesurfer/sub-2002/mri
mris_place_surface --thickness ../surf/lh.white ../surf/lh.pial 20 5 ../surf/lh.thickness

#-----------------------------------------
#@# Curvature Stats lh Wed Dec 13 22:09:31 UTC 2023

 mris_curvature_stats -m --writeCurvatureFiles -G -o ../stats/lh.curv.stats -F smoothwm sub-2002 lh curv sulc 

#-----------------------------------------
#@# Cortical Parc 2 lh Wed Dec 13 22:09:32 UTC 2023

 mris_ca_label -l ../label/lh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 sub-2002 lh ../surf/lh.sphere.reg /opt/freesurfer/average/lh.CDaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/lh.aparc.a2009s.annot 

#-----------------------------------------
#@# Cortical Parc 3 lh Wed Dec 13 22:09:40 UTC 2023

 mris_ca_label -l ../label/lh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 sub-2002 lh ../surf/lh.sphere.reg /opt/freesurfer/average/lh.DKTaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/lh.aparc.DKTatlas.annot 

#-----------------------------------------
#@# WM/GM Contrast lh Wed Dec 13 22:09:45 UTC 2023

 pctsurfcon --s sub-2002 --lh-only 



#---------------------------------
# New invocation of recon-all Wed Dec 13 22:22:06 UTC 2023 
#--------------------------------------------
#@# AutoDetGWStats lh Wed Dec 13 22:22:08 UTC 2023
cd /output/sourcedata/freesurfer/sub-2002/mri
mris_autodet_gwstats --o ../surf/autodet.gw.stats.lh.dat --i brain.finalsurfs.mgz --wm wm.mgz --surf ../surf/lh.orig.premesh
  Update not needed
#--------------------------------------------
#@# WhitePreAparc lh Wed Dec 13 22:22:08 UTC 2023
cd /output/sourcedata/freesurfer/sub-2002/mri
mris_place_surface --adgws-in ../surf/autodet.gw.stats.lh.dat --wm wm.mgz --threads 8 --invol brain.finalsurfs.mgz --lh --i ../surf/lh.orig --o ../surf/lh.white.preaparc --white --seg aseg.presurf.mgz --nsmooth 5
   Update not needed
#--------------------------------------------
#@# CortexLabel lh Wed Dec 13 22:22:08 UTC 2023
cd /output/sourcedata/freesurfer/sub-2002/mri
mri_label2label --label-cortex ../surf/lh.white.preaparc aseg.presurf.mgz 0 ../label/lh.cortex.label
   Update not needed
#--------------------------------------------
#@# CortexLabel+HipAmyg lh Wed Dec 13 22:22:08 UTC 2023
cd /output/sourcedata/freesurfer/sub-2002/mri
mri_label2label --label-cortex ../surf/lh.white.preaparc aseg.presurf.mgz 1 ../label/lh.cortex+hipamyg.label
   Update not needed
#@# white curv lh Wed Dec 13 22:22:08 UTC 2023
cd /output/sourcedata/freesurfer/sub-2002/mri
mris_place_surface --curv-map ../surf/lh.white 2 10 ../surf/lh.curv
   Update not needed
#@# white area lh Wed Dec 13 22:22:08 UTC 2023
cd /output/sourcedata/freesurfer/sub-2002/mri
mris_place_surface --area-map ../surf/lh.white ../surf/lh.area
   Update not needed
#@# pial curv lh Wed Dec 13 22:22:08 UTC 2023
cd /output/sourcedata/freesurfer/sub-2002/mri
mris_place_surface --curv-map ../surf/lh.pial 2 10 ../surf/lh.curv.pial
   Update not needed
#@# pial area lh Wed Dec 13 22:22:08 UTC 2023
cd /output/sourcedata/freesurfer/sub-2002/mri
mris_place_surface --area-map ../surf/lh.pial ../surf/lh.area.pial
   Update not needed
#@# thickness lh Wed Dec 13 22:22:08 UTC 2023
cd /output/sourcedata/freesurfer/sub-2002/mri
mris_place_surface --thickness ../surf/lh.white ../surf/lh.pial 20 5 ../surf/lh.thickness
   Update not needed
#@# area and vertex vol lh Wed Dec 13 22:22:08 UTC 2023
cd /output/sourcedata/freesurfer/sub-2002/mri
mris_place_surface --thickness ../surf/lh.white ../surf/lh.pial 20 5 ../surf/lh.thickness
   Update not needed
#-----------------------------------------
#@# Parcellation Stats lh Wed Dec 13 22:22:08 UTC 2023

 mris_anatomical_stats -th3 -mgz -noglobal -cortex ../label/lh.cortex.label -f ../stats/lh.aparc.stats -b -a ../label/lh.aparc.annot -c ../label/aparc.annot.ctab sub-2002 lh white 


 mris_anatomical_stats -th3 -mgz -noglobal -cortex ../label/lh.cortex.label -f ../stats/lh.aparc.pial.stats -b -a ../label/lh.aparc.annot -c ../label/aparc.annot.ctab sub-2002 lh pial 

#-----------------------------------------
#@# Parcellation Stats 2 lh Wed Dec 13 22:22:17 UTC 2023

 mris_anatomical_stats -th3 -mgz -noglobal -cortex ../label/lh.cortex.label -f ../stats/lh.aparc.a2009s.stats -b -a ../label/lh.aparc.a2009s.annot -c ../label/aparc.annot.a2009s.ctab sub-2002 lh white 

#-----------------------------------------
#@# Parcellation Stats 3 lh Wed Dec 13 22:22:21 UTC 2023

 mris_anatomical_stats -th3 -mgz -noglobal -cortex ../label/lh.cortex.label -f ../stats/lh.aparc.DKTatlas.stats -b -a ../label/lh.aparc.DKTatlas.annot -c ../label/aparc.annot.DKTatlas.ctab sub-2002 lh white 

#--------------------------------------------
#@# BA_exvivo Labels lh Wed Dec 13 22:22:26 UTC 2023

 mri_label2label --srcsubject fsaverage --srclabel /output/sourcedata/freesurfer/fsaverage/label/lh.BA1_exvivo.label --trgsubject sub-2002 --trglabel ./lh.BA1_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /output/sourcedata/freesurfer/fsaverage/label/lh.BA2_exvivo.label --trgsubject sub-2002 --trglabel ./lh.BA2_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /output/sourcedata/freesurfer/fsaverage/label/lh.BA3a_exvivo.label --trgsubject sub-2002 --trglabel ./lh.BA3a_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /output/sourcedata/freesurfer/fsaverage/label/lh.BA3b_exvivo.label --trgsubject sub-2002 --trglabel ./lh.BA3b_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /output/sourcedata/freesurfer/fsaverage/label/lh.BA4a_exvivo.label --trgsubject sub-2002 --trglabel ./lh.BA4a_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /output/sourcedata/freesurfer/fsaverage/label/lh.BA4p_exvivo.label --trgsubject sub-2002 --trglabel ./lh.BA4p_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /output/sourcedata/freesurfer/fsaverage/label/lh.BA6_exvivo.label --trgsubject sub-2002 --trglabel ./lh.BA6_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /output/sourcedata/freesurfer/fsaverage/label/lh.BA44_exvivo.label --trgsubject sub-2002 --trglabel ./lh.BA44_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /output/sourcedata/freesurfer/fsaverage/label/lh.BA45_exvivo.label --trgsubject sub-2002 --trglabel ./lh.BA45_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /output/sourcedata/freesurfer/fsaverage/label/lh.V1_exvivo.label --trgsubject sub-2002 --trglabel ./lh.V1_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /output/sourcedata/freesurfer/fsaverage/label/lh.V2_exvivo.label --trgsubject sub-2002 --trglabel ./lh.V2_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /output/sourcedata/freesurfer/fsaverage/label/lh.MT_exvivo.label --trgsubject sub-2002 --trglabel ./lh.MT_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /output/sourcedata/freesurfer/fsaverage/label/lh.entorhinal_exvivo.label --trgsubject sub-2002 --trglabel ./lh.entorhinal_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /output/sourcedata/freesurfer/fsaverage/label/lh.perirhinal_exvivo.label --trgsubject sub-2002 --trglabel ./lh.perirhinal_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /output/sourcedata/freesurfer/fsaverage/label/lh.FG1.mpm.vpnl.label --trgsubject sub-2002 --trglabel ./lh.FG1.mpm.vpnl.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /output/sourcedata/freesurfer/fsaverage/label/lh.FG2.mpm.vpnl.label --trgsubject sub-2002 --trglabel ./lh.FG2.mpm.vpnl.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /output/sourcedata/freesurfer/fsaverage/label/lh.FG3.mpm.vpnl.label --trgsubject sub-2002 --trglabel ./lh.FG3.mpm.vpnl.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /output/sourcedata/freesurfer/fsaverage/label/lh.FG4.mpm.vpnl.label --trgsubject sub-2002 --trglabel ./lh.FG4.mpm.vpnl.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /output/sourcedata/freesurfer/fsaverage/label/lh.hOc1.mpm.vpnl.label --trgsubject sub-2002 --trglabel ./lh.hOc1.mpm.vpnl.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /output/sourcedata/freesurfer/fsaverage/label/lh.hOc2.mpm.vpnl.label --trgsubject sub-2002 --trglabel ./lh.hOc2.mpm.vpnl.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /output/sourcedata/freesurfer/fsaverage/label/lh.hOc3v.mpm.vpnl.label --trgsubject sub-2002 --trglabel ./lh.hOc3v.mpm.vpnl.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /output/sourcedata/freesurfer/fsaverage/label/lh.hOc4v.mpm.vpnl.label --trgsubject sub-2002 --trglabel ./lh.hOc4v.mpm.vpnl.label --hemi lh --regmethod surface 


 mris_label2annot --s sub-2002 --ctab /opt/freesurfer/average/colortable_vpnl.txt --hemi lh --a mpm.vpnl --maxstatwinner --noverbose --l lh.FG1.mpm.vpnl.label --l lh.FG2.mpm.vpnl.label --l lh.FG3.mpm.vpnl.label --l lh.FG4.mpm.vpnl.label --l lh.hOc1.mpm.vpnl.label --l lh.hOc2.mpm.vpnl.label --l lh.hOc3v.mpm.vpnl.label --l lh.hOc4v.mpm.vpnl.label 


 mri_label2label --srcsubject fsaverage --srclabel /output/sourcedata/freesurfer/fsaverage/label/lh.BA1_exvivo.thresh.label --trgsubject sub-2002 --trglabel ./lh.BA1_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /output/sourcedata/freesurfer/fsaverage/label/lh.BA2_exvivo.thresh.label --trgsubject sub-2002 --trglabel ./lh.BA2_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /output/sourcedata/freesurfer/fsaverage/label/lh.BA3a_exvivo.thresh.label --trgsubject sub-2002 --trglabel ./lh.BA3a_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /output/sourcedata/freesurfer/fsaverage/label/lh.BA3b_exvivo.thresh.label --trgsubject sub-2002 --trglabel ./lh.BA3b_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /output/sourcedata/freesurfer/fsaverage/label/lh.BA4a_exvivo.thresh.label --trgsubject sub-2002 --trglabel ./lh.BA4a_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /output/sourcedata/freesurfer/fsaverage/label/lh.BA4p_exvivo.thresh.label --trgsubject sub-2002 --trglabel ./lh.BA4p_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /output/sourcedata/freesurfer/fsaverage/label/lh.BA6_exvivo.thresh.label --trgsubject sub-2002 --trglabel ./lh.BA6_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /output/sourcedata/freesurfer/fsaverage/label/lh.BA44_exvivo.thresh.label --trgsubject sub-2002 --trglabel ./lh.BA44_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /output/sourcedata/freesurfer/fsaverage/label/lh.BA45_exvivo.thresh.label --trgsubject sub-2002 --trglabel ./lh.BA45_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /output/sourcedata/freesurfer/fsaverage/label/lh.V1_exvivo.thresh.label --trgsubject sub-2002 --trglabel ./lh.V1_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /output/sourcedata/freesurfer/fsaverage/label/lh.V2_exvivo.thresh.label --trgsubject sub-2002 --trglabel ./lh.V2_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /output/sourcedata/freesurfer/fsaverage/label/lh.MT_exvivo.thresh.label --trgsubject sub-2002 --trglabel ./lh.MT_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /output/sourcedata/freesurfer/fsaverage/label/lh.entorhinal_exvivo.thresh.label --trgsubject sub-2002 --trglabel ./lh.entorhinal_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /output/sourcedata/freesurfer/fsaverage/label/lh.perirhinal_exvivo.thresh.label --trgsubject sub-2002 --trglabel ./lh.perirhinal_exvivo.thresh.label --hemi lh --regmethod surface 


 mris_label2annot --s sub-2002 --hemi lh --ctab /opt/freesurfer/average/colortable_BA.txt --l lh.BA1_exvivo.label --l lh.BA2_exvivo.label --l lh.BA3a_exvivo.label --l lh.BA3b_exvivo.label --l lh.BA4a_exvivo.label --l lh.BA4p_exvivo.label --l lh.BA6_exvivo.label --l lh.BA44_exvivo.label --l lh.BA45_exvivo.label --l lh.V1_exvivo.label --l lh.V2_exvivo.label --l lh.MT_exvivo.label --l lh.perirhinal_exvivo.label --l lh.entorhinal_exvivo.label --a BA_exvivo --maxstatwinner --noverbose 


 mris_label2annot --s sub-2002 --hemi lh --ctab /opt/freesurfer/average/colortable_BA.txt --l lh.BA1_exvivo.thresh.label --l lh.BA2_exvivo.thresh.label --l lh.BA3a_exvivo.thresh.label --l lh.BA3b_exvivo.thresh.label --l lh.BA4a_exvivo.thresh.label --l lh.BA4p_exvivo.thresh.label --l lh.BA6_exvivo.thresh.label --l lh.BA44_exvivo.thresh.label --l lh.BA45_exvivo.thresh.label --l lh.V1_exvivo.thresh.label --l lh.V2_exvivo.thresh.label --l lh.MT_exvivo.thresh.label --l lh.perirhinal_exvivo.thresh.label --l lh.entorhinal_exvivo.thresh.label --a BA_exvivo.thresh --maxstatwinner --noverbose 


 mris_anatomical_stats -th3 -mgz -noglobal -f ../stats/lh.BA_exvivo.stats -b -a ./lh.BA_exvivo.annot -c ./BA_exvivo.ctab sub-2002 lh white 


 mris_anatomical_stats -th3 -mgz -f ../stats/lh.BA_exvivo.thresh.stats -noglobal -b -a ./lh.BA_exvivo.thresh.annot -c ./BA_exvivo.thresh.ctab sub-2002 lh white 


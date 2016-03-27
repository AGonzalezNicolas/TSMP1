#! /bin/ksh

initSetup(){
  if [[ $forcingdir_clm == "" ]] ; then ;forcingdir_clm="/work/slts/slts00/tsmp/TerrSysMPdb/idealized/1200";fi
  if [[ $forcingdir_cos == "" ]] ; then ;forcingdir_cos="";fi
  if [[ $forcingdir_oas == "" ]] ; then ;forcingdir_oas="/work/slts/slts00/tsmp/TerrSysMPdb/idealized/1200/oasis3";fi
  if [[ $forcingdir_pfl == "" ]] ; then ;forcingdir_pfl="";fi


  if [[ $namelist_clm == "" ]] ; then ; namelist_clm=$rootdir/bldsva/setups/ideal1200600/lnd.stdin ; fi
  if [[ $namelist_cos == "" ]] ; then ; namelist_cos=$rootdir/bldsva/setups/ideal1200600/lmrun_uc ; fi
  if [[ $namelist_pfl == "" ]] ; then ; namelist_pfl=$rootdir/bldsva/setups/ideal1200600/coup_oas.tcl ; fi


  defaultNppn=48
  defaultCLMProcX=4
  defaultCLMProcY=2
  defaultCOSProcX=8
  defaultCOSProcY=8
  defaultPFLProcX=4
  defaultPFLProcY=4


  gx_clm=1200
  gy_clm=1200
  dt_clm=900
  res="1200x1200"

  gx_cos=600
  gy_cos=600
  dt_cos=10
  nbndlines=4

  gx_pfl=1200
  gy_pfl=1200
  dt_pfl=0.25
  pflrunname="rurlaf"

  cplfreq1=900
  cplfreq2=900


  if [[ $namelist_oas == "" ]] ; then  
    if [[ $withPFL == "false" && $withCOS == "true" ]]; then
      namelist_oas=$rootdir/bldsva/data_oas3/namcouple_cos_clm
    fi	
    if [[ $withPFL == "true" && $withCOS == "false" ]]; then
      namelist_oas=$rootdir/bldsva/data_oas3/namcouple_pfl_clm
    fi
    if [[ $withPFL == "true" && $withCOS == "true" ]]; then
      namelist_oas=$rootdir/bldsva/data_oas3/namcouple_cos_clm_pfl
    fi
  fi

  fn_finidat="$WORK/tsmp/TSMPForecastNRW$restDate-00/run/clmoas.clm2.r.${yyyy}-${mm}-${dd}-00000.nc"
  pfbfilename="/work/slts/slts06/tsmp/TSMPForecastNRW$restDate-00/run/rurlaf.out.press.00024.pfb"

}

finalizeSetup(){
route "${cblue}>> finalizeSetup${cnormal}"
  comment "   copy clmgrid into rundir"
    cp $forcingdir_clm/clm3.5/ideal/grid* $rundir/clmgrid.nc >> $log_file 2>> $err_file
  check  
  if [[ $withOAS == "true" ]] then
    comment "   copy oasis remappingfiles into rundir"
      cp $forcingdir_oas/* $rundir >> $log_file 2>> $err_file
    check
    if [[ $withOASMCT == "true" ]] then
      for x in $rundir/*BILINEA* ;do 
        comment "   rename oasis3 remapping files" 
          mv $x $(echo $x | sed "s/BILINEA/BILINEAR/") >> $log_file 2>> $err_file
        check 
      done
    fi  
  fi  

route "${cblue}<< finalizeSetup${cnormal}"
}

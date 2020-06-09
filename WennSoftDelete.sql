/* Start Script */

/* Pathnames */ delete DYNAMICS..SY02100 where DICTID = 131

/* Tasks */ delete DYNAMICS..SY01403 where CmdDictID = 131

/* Shortcut Bar Options */ delete DYNAMICS..SY01990 where ScbTargetLongOne = 131

/* Menu Options */ delete DYNAMICS..SY07110 where CmdParentDictID= 131 or CmdDictID = 131

/* Navigation Buttons */ delete DYNAMICS..SY07130 where CmdParentDictID = 131

/* Homepage Layout */ delete DYNAMICS..SY08100 where DICTID= 131

/* Homepage Subsections */ delete DYNAMICS..SY08120 where DICTID = 131

/* Homepage Metrics */ delete DYNAMICS..SY08130 where DICTID = 131

/* Homepage Quicklinks */ delete DYNAMICS..SY08140 where CmdDictID = 131

/* Setup Checklist Options */ delete DYNAMICS..SY40600 where CmdParentDictID = 131 or CmdDictID = 131

/* Setup Checklist Assignations */ delete DYNAMICS..SY40601 where CmdDictID = 131

/* My Reports */ delete DYNAMICS..SY70700 where Report_Series_DictID = 131

/* Smart List Tables */ delete DYNAMICS..GOTO100 where Smar­tList_ID like 'WENN%’ delete  DYNAMICS..GOTO200 where SmartList_ID like 'WENN%’ delete DYNAMICS..SLB10400 where SmartList_ID  like 'WENN%’

/* End Script */
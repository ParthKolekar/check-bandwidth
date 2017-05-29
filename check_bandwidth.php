<?php

foreach (array_chunk($this->DS, 2) as $KEY=>$VAL) {
	$unit = $VAL[0]['UNIT'];
	$interface = explode('_', $VAL[0]['NAME'])[0];
	if ($interface === "total" and count($this->DS) <= 4) {
		continue;
	}
	$ds_name[$KEY] = "Bandwidth ($interface)";
	$opt[$KEY] = "--vertical-label $unit/s --title \"Traffic for $hostname / $servicedesc ($interface)\"";
	$def[$KEY] = "";
	foreach ($VAL as $dIndex=>$VAL) {
		$def[$KEY] .= rrd::def("var$dIndex", $VAL['RRDFILE'], $VAL['DS'], "AVERAGE");
	}
	$def[$KEY] .= rrd::area("var0", "#00ff00", "RX");
	$def[$KEY] .= rrd::gprint("var0", "MIN", "Min\: %.2lf $unit/s");
	$def[$KEY] .= rrd::gprint("var0", "AVERAGE", "Avg\: %.2lf $unit/s");
	$def[$KEY] .= rrd::gprint("var0", "MAX", "Max\: %.2lf $unit/s");
	$def[$KEY] .= rrd::gprint("var0", "LAST", "Cur\: %.2lf $unit/s\\n");
	
	$def[$KEY] .= rrd::line1("var1", "#ff0000", "TX");
	$def[$KEY] .= rrd::gprint("var1", "MIN", "Min\: %.2lf $unit/s");
	$def[$KEY] .= rrd::gprint("var1", "AVERAGE", "Avg\: %.2lf $unit/s");
	$def[$KEY] .= rrd::gprint("var1", "MAX", "Max\: %.2lf $unit/s");
	$def[$KEY] .= rrd::gprint("var1", "LAST", "Cur\: %.2lf $unit/s\\n");
}
?>


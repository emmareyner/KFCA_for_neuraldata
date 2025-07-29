Compiled data for each tested concentration (10^-4, -5, -6, -7, & -8), and for unc-13, tested at 10^-4 concentration. Note that not all odors were tested under 10^-7, -8, and unc-13 conditions. In these cases, odor order is preserved and untested odors have 0 values.

odor_list: list of 23 odorants, in the order they appear in the other matrices
neuron_pairs: list of 11 chemosensory neurons, in the order they appear in the other matrices
peak_F: odor x neuron matrix of peak Delta F/F_0 values
peak_SD: odor x neuron matrix of standard deviation of peak values
peak_SE: odor x neuron matrix of standard error of peak values
compiled_LR_ordered: cell array by odor, each cell contains individual and mean traces for each neuron. Entries beyond the 11 chemosensory neurons can be ignored (traces excluded during manual proofreading).
Ns: odor x neuron matrix of the number of usable trials, after excluding occluded neurons and mistracking instances
ap_time: time in seconds for plotting traces
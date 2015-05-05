
-module(ling_iopvars).
-export([var_order/0]).
-export([fit_args/2]).
-export([var_args/2]).
-export([var_index/2]).
-export([var_by_index/1]).

var_order() -> [
		{move,0},
	{move,1},
	{l_call,0},
	{test_heap,0},
	{move,2},
	{badmatch,0},
	{move,3},
	{l_put_tuple,0},
	{move,4},
	{move2,1},
	{get_tuple_element,0},
	{move2,0},
	{put_list,0},
	{is_tuple_of_arity,1},
	{get_tuple_element,1},
	{l_call_only,0},
	{call_bif,7},
	{l_bs_start_match2,0},
	{l_bs_test_zero_tail2,0},
	{l_bs_match_string,0},
	{l_is_eq_exact_immed,0},
	{put_list,1},
	{is_tuple_of_arity,0},
	{l_is_eq_exact_immed,1},
	{get_list,0},
	{l_put_tuple,1},
	{move,5},
	{l_call_ext,85},
	{l_move_call_ext,0},
	{return,0},
	{move2,2},
	{l_is_ge,0},
	{l_move_call_last,0},
	{l_make_fun,0},
	{is_tuple_of_arity,2},
	{extract_next_element2,0},
	{move_deallocate_return,0},
	{call_bif,3},
	{l_allocate,0},
	{l_fetch,0},
	{l_trim,0},
	{is_nil,0},
	{is_nonempty_list,0},
	{move_return,25},
	{l_move_call_ext,1},
	{deallocate_return,0},
	{case_end,0},
	{get_list,1},
	{l_allocate,1},
	{l_fetch,1},
	{jump,0},
	{extract_next_element,0},
	{put_list,3},
	{l_is_eq_exact_immed,2},
	{move2,3},
	{l_fetch,2},
	{l_is_eq_exact,0},
	{call_bif,8},
	{l_allocate,2},
	{l_is_eq_exact_immed,3},
	{get_tuple_element,2},
	{l_move_call,26},
	{deallocate_return,1},
	{move_return,0},
	{init2,0},
	{get_tuple_element,3},
	{put_list,2},
	{init,0},
	{move2,4},
	{l_is_eq_exact_immed,4},
	{call_bif,9},
	{l_fetch,3},
	{deallocate_return,2},
	{extract_next_element,1},
	{is_nonempty_list,1},
	{put_list,4},
	{l_put_tuple,2},
	{l_allocate,3},
	{is_tuple_of_arity,3},
	{move2,5},
	{init,1},
	{get_tuple_element,4},
	{l_fetch,4},
	{init3,0},
	{get_list,2},
	{l_move_call_ext,38},
	{allocate_init,0},
	{l_is_eq_exact_immed,5},
	{l_trim,1},
	{test_heap_1_put_list,0},
	{l_is_lt,0},
	{l_is_eq_exact_literal,0},
	{call_bif,6},
	{call_bif,45},
	{l_allocate_zero,0},
	{allocate_heap,0},
	{is_tuple,0},
	{move_return,1},
	{is_nonempty_list,2},
	{l_allocate_zero,1},
	{move,6},
	{l_call_last,0},
	{init,2},
	{l_gc_bif1,0},
	{deallocate_return,3},
	{get_tuple_element,5},
	{l_increment,0},
	{call_bif,2},
	{is_nonempty_list_allocate,0},
	{l_select_val_atoms,0},
	{l_move_call,0},
	{l_is_eq_exact_immed,6},
	{call_bif,5},
	{move_deallocate_return,1},
	{is_nonempty_list,3},
	{extract_next_element,2},
	{is_list,0},
	{l_select_val2,3},
	{l_fetch,5},
	{extract_next_element3,0},
	{is_nil,1},
	{move_deallocate_return,2},
	{l_call_last,1},
	{l_trim,2},
	{l_call_last,2},
	{get_list,3},
	{l_select_val2,0},
	{l_move_call_only,12},
	{is_nil,2},
	{move2,6},
	{l_allocate,4},
	{l_move_call_only,0},
	{extract_next_element2,1},
	{move_return,2},
	{test_arity,0},
	{move2,7},
	{l_call_ext,0},
	{l_new_bs_put_integer_imm,0},
	{l_select_val2,4},
	{l_move_call_only,1},
	{l_select_val2,1},
	{remove_message,0},
	{init,3},
	{l_allocate_zero,2},
	{l_plus,0},
	{l_catch,0},
	{deallocate_return,4},
	{is_nonempty_list,4},
	{bif1_body,0},
	{l_put_tuple,3},
	{extract_next_element,3},
	{l_is_eq_exact_immed,7},
	{move_jump,14},
	{move,7},
	{l_allocate_zero,3},
	{l_move_call_only,2},
	{l_select_tuple_arity2,0},
	{l_bs_start_match2,1},
	{catch_end,0},
	{move_return,3},
	{is_nonempty_list,5},
	{l_is_eq_exact_immed,8},
	{l_call_last,3},
	{l_move_call_only,3},
	{l_call_last,4},
	{get_list,4},
	{move_return,4},
	{move,8},
	{test_arity,1},
	{move_return,5},
	{is_nonempty_list,6},
	{l_call_fun,0},
	{l_increment,1},
	{put_list,5},
	{init,4},
	{l_is_eq,0},
	{l_select_val2,2},
	{l_move_call_ext,2},
	{l_call_ext_only,4},
	{l_bs_get_binary_all_reuse,0},
	{send,0},
	{set_tuple_element,0},
	{bif2_body,0},
	{extract_next_element2,2},
	{l_move_call,1},
	{l_catch,1},
	{is_nil,3},
	{move_deallocate_return,3},
	{call_bif,10},
	{extract_next_element2,3},
	{badmatch,1},
	{is_nonempty_list,7},
	{l_increment,2},
	{l_is_eq_exact_immed,9},
	{case_end,1},
	{extract_next_element,4},
	{l_trim,3},
	{l_move_call_ext_last,0},
	{is_nonempty_list,8},
	{l_move_call_last,1},
	{badmatch,2},
	{deallocate_return,5},
	{l_fetch,6},
	{l_select_val_atoms,1},
	{l_bs_add,0},
	{l_allocate,5},
	{l_select_val_smallints,0},
	{l_move_call,2},
	{l_select_tuple_arity2,1},
	{is_nonempty_list,9},
	{l_bs_test_zero_tail2,1},
	{l_loop_rec,0},
	{l_move_call_ext,3},
	{is_nil,4},
	{l_is_ne_exact_immed,0},
	{l_increment,3},
	{l_is_ne,0},
	{l_move_call,3},
	{l_plus,1},
	{catch_end,1},
	{l_move_call,4},
	{init,5},
	{l_call_last,6},
	{l_call_last,5},
	{l_minus,0},
	{l_move_call_ext,4},
	{l_bs_match_string,1},
	{l_allocate_zero,4},
	{extract_next_element,5},
	{l_select_val2,6},
	{l_bs_init_heap_bin,0},
	{l_allocate_zero,5},
	{l_bs_start_match2,2},
	{l_fetch,7},
	{l_call_ext_last,0},
	{is_nonempty_list_allocate,1},
	{l_bs_restore2,0},
	{loop_rec_end,0},
	{call_bif,11},
	{l_bs_get_utf16,0},
	{l_fast_element,1},
	{l_gc_bif1,1},
	{l_trim,4},
	{move,9},
	{wait,0},
	{l_is_eq_exact_immed,10},
	{extract_next_element2,4},
	{is_atom,0},
	{call_bif,12},
	{int_code_end,0},
	{l_call_fun_last,0},
	{l_move_call_ext_only,0},
	{get_tuple_element,6},
	{move_deallocate_return,4},
	{bs_context_to_binary,0},
	{init,6},
	{l_move_call_ext,5},
	{extract_next_element,6},
	{self,0},
	{is_nil,5},
	{l_move_call_ext,6},
	{l_call_ext_last,1},
	{l_call_fun,1},
	{l_is_eq_exact_immed,11},
	{l_move_call,5},
	{l_is_ne_exact_immed,1},
	{is_tuple,1},
	{extract_next_element,7},
	{l_move_call_last,2},
	{l_times,0},
	{l_bs_test_unit_8,0},
	{l_allocate,6},
	{badmatch,3},
	{l_move_call_ext_only,1},
	{l_bs_test_zero_tail2,2},
	{l_move_call_ext,7},
	{l_move_call_ext,8},
	{move_return,6},
	{l_put_tuple,4},
	{call_bif,13},
	{l_catch,2},
	{bif1_body,1},
	{l_select_val_smallints,1},
	{raise,0},
	{call_bif,14},
	{is_nil,6},
	{l_move_call,6},
	{l_move_call_ext,9},
	{l_select_val2,7},
	{is_integer,0},
	{extract_next_element3,1},
	{l_minus,1},
	{is_nonempty_list,10},
	{call_bif,15},
	{l_bs_save2,0},
	{l_call_ext_last,2},
	{extract_next_element,8},
	{l_call_ext,1},
	{l_new_bs_put_binary_all,0},
	{l_move_call_ext_only,7},
	{is_nil,7},
	{deallocate_return,6},
	{l_move_call_only,4},
	{self,1},
	{l_call_ext,2},
	{l_select_val2,5},
	{case_end,2},
	{allocate_heap_zero,0},
	{call_bif,16},
	{is_nonempty_list,11},
	{extract_next_element2,5},
	{apply,0},
	{try_end,0},
	{l_move_call,7},
	{call_bif,17},
	{l_fast_element,0},
	{test_heap_1_put_list,1},
	{call_bif,19},
	{call_bif,18},
	{call_bif,20},
	{l_bs_test_zero_tail2,3},
	{l_move_call_ext,10},
	{is_nil,8},
	{get_tuple_element,7},
	{call_bif,21},
	{l_call_ext,3},
	{catch_end,2},
	{l_put_tuple,5},
	{is_list,1},
	{extract_next_element3,2},
	{get_list,7},
	{l_bif2,0},
	{call_bif,22},
	{init,7},
	{try_end,1},
	{l_bs_get_integer_32,0},
	{test_arity,2},
	{l_trim,5},
	{l_increment,4},
	{l_move_call,8},
	{l_call_ext,4},
	{extract_next_element,9},
	{l_move_call_ext,11},
	{l_is_ne_exact,0},
	{l_bs_get_binary2,0},
	{extract_next_element,24},
	{is_integer,1},
	{l_band,0},
	{move_jump,0},
	{l_is_eq_exact_immed,12},
	{l_call_fun,2},
	{move_deallocate_return,5},
	{l_times,1},
	{l_move_call_last,3},
	{put_list,7},
	{l_call_last,7},
	{l_move_call_ext_only,3},
	{l_fast_element,2},
	{l_is_eq_exact_literal,7},
	{extract_next_element,10},
	{extract_next_element2,6},
	{is_tuple,2},
	{l_catch,3},
	{l_call_ext,5},
	{l_call_ext,6},
	{l_bif2,1},
	{l_is_eq_exact_immed,13},
	{is_binary,0},
	{l_call_ext,7},
	{extract_next_element2,7},
	{l_allocate_zero,6},
	{l_bsr,0},
	{l_fetch,22},
	{move,10},
	{extract_next_element3,3},
	{l_is_eq_exact_immed,14},
	{get_list,5},
	{is_atom,1},
	{extract_next_element3,4},
	{l_bs_get_binary_all2,0},
	{call_bif,23},
	{l_move_call_only,5},
	{call_bif,24},
	{is_nonempty_list,12},
	{l_is_eq_exact_immed,15},
	{l_fetch,8},
	{l_is_eq_exact_literal,1},
	{l_move_call_ext,12},
	{l_bs_get_integer_8,0},
	{l_is_ne_exact_immed,2},
	{put_list,6},
	{is_nil,9},
	{l_bsl,0},
	{l_select_val2,9},
	{is_list,2},
	{l_allocate_zero,9},
	{l_put_tuple,6},
	{l_call_ext,8},
	{l_bs_init_fail,0},
	{get_list,6},
	{l_bif2,2},
	{deallocate_return,7},
	{l_bs_get_integer_8,1},
	{set_tuple_element,1},
	{l_move_call_ext,13},
	{l_select_val2,16},
	{call_bif,26},
	{call_bif,25},
	{l_call_ext,9},
	{l_move_call,9},
	{l_is_eq_exact_literal,2},
	{l_bs_get_integer_32,1},
	{extract_next_element,11},
	{l_is_eq_exact_literal,3},
	{l_is_eq_exact_immed,16},
	{l_fetch,9},
	{l_bif2,3},
	{is_nil,10},
	{l_bsl,1},
	{l_bs_test_zero_tail2,5},
	{l_trim,6},
	{l_rem,0},
	{move2,8},
	{l_move_call_ext,14},
	{timeout,0},
	{is_binary,1},
	{catch_end,3},
	{l_move_call_ext_last,1},
	{l_call_last,8},
	{l_allocate_zero,7},
	{l_select_val2,10},
	{l_fetch,10},
	{l_fmul,0},
	{l_bs_match_string,2},
	{call_bif,27},
	{extract_next_element3,10},
	{l_gc_bif1,2},
	{move_deallocate_return,6},
	{l_allocate,7},
	{l_move_call,10},
	{l_catch,4},
	{is_nonempty_list,36},
	{l_bs_get_integer_small_imm,0},
	{extract_next_element,12},
	{l_is_eq_exact_immed,36},
	{l_call_ext,10},
	{move_jump,1},
	{l_fcheckerror,0},
	{fclearerror,0},
	{move_return,7},
	{l_bs_append,0},
	{node,0},
	{l_move_call,11},
	{extract_next_element2,16},
	{l_move_call_last,4},
	{l_is_eq_exact_immed,17},
	{l_call_ext,11},
	{extract_next_element,13},
	{l_move_call_ext_only,2},
	{l_is_ne_exact_immed,11},
	{l_is_eq_exact_immed,18},
	{l_get,1},
	{l_element,2},
	{is_integer,2},
	{is_integer,7},
	{l_move_call_ext_last,4},
	{l_bif2,4},
	{l_move_call_ext,16},
	{l_call_fun,3},
	{l_move_call,12},
	{call_bif,28},
	{is_nonempty_list,13},
	{try_end,2},
	{is_nil,11},
	{l_select_tuple_arity,1},
	{is_tuple,3},
	{l_move_call_ext_last,2},
	{node,1},
	{is_nonempty_list,14},
	{l_bs_restore2,1},
	{l_move_call_ext,17},
	{l_band,1},
	{l_is_eq_exact_immed,19},
	{l_get,4},
	{call_bif,29},
	{call_bif,1},
	{l_fetch,11},
	{l_gc_bif1,3},
	{is_nil,12},
	{l_move_call_only,6},
	{l_move_call,13},
	{system_limit,0},
	{l_element,0},
	{l_select_tuple_arity,0},
	{bif2_body,1},
	{is_float,1},
	{extract_next_element2,8},
	{l_select_val2,8},
	{is_integer_allocate,0},
	{is_atom,2},
	{l_int_div,0},
	{l_get,2},
	{l_gc_bif1,5},
	{l_move_call_ext,18},
	{is_nil,29},
	{l_is_eq_exact_immed,20},
	{call_bif,30},
	{l_bor,0},
	{l_bif1,0},
	{l_catch,5},
	{l_get,0},
	{l_fetch,12},
	{l_call_ext,13},
	{l_call_ext,12},
	{is_tuple,9},
	{try_end,3},
	{init,8},
	{call_bif,32},
	{call_bif,31},
	{is_nil,13},
	{apply_last,0},
	{call_bif,33},
	{l_int_div,1},
	{call_bif,34},
	{extract_next_element,14},
	{put_list,9},
	{is_nonempty_list,15},
	{case_end,11},
	{l_bs_skip_bits2,0},
	{l_call_ext,14},
	{deallocate_return,8},
	{l_call_ext_last,3},
	{l_move_call_ext,19},
	{l_is_ne_exact_immed,3},
	{extract_next_element3,5},
	{is_integer,3},
	{l_trim,7},
	{l_is_eq_exact_immed,21},
	{l_increment,8},
	{call_bif,4},
	{is_nonempty_list,16},
	{is_list,7},
	{l_element,4},
	{extract_next_element3,6},
	{l_is_eq_exact_literal,4},
	{test_arity,3},
	{move_deallocate_return,7},
	{l_move_call_ext_only,4},
	{l_fadd,0},
	{l_call_ext,16},
	{l_call_ext,15},
	{try_end,5},
	{try_end,4},
	{l_move_call_ext,20},
	{l_bs_match_string,3},
	{call_bif,35},
	{l_call_ext,17},
	{fmove_1,0},
	{l_increment,6},
	{if_end,0},
	{l_increment,5},
	{l_call_ext,18},
	{is_integer,4},
	{l_bs_get_utf8,0},
	{is_list,3},
	{is_atom,3},
	{l_fetch,13},
	{l_bs_init_bits_fail,0},
	{call_bif,36},
	{l_call_ext,19},
	{l_bs_test_zero_tail2,4},
	{fconv,0},
	{case_end,3},
	{catch_end,4},
	{l_make_export,0},
	{l_rem,1},
	{self,2},
	{fmove_2,0},
	{l_bor,1},
	{l_call_ext_last,4},
	{call_bif,37},
	{l_call_last,9},
	{bif1_body,2},
	{is_binary,2},
	{l_fetch,14},
	{l_call_ext,20},
	{l_move_call_ext,21},
	{l_bs_skip_bits_all2,0},
	{l_catch,7},
	{l_move_call_ext,22},
	{extract_next_element,15},
	{badmatch,4},
	{l_move_call,14},
	{self,5},
	{get_tuple_element,8},
	{l_move_call_ext,23},
	{l_move_call_ext,24},
	{l_call_ext,21},
	{l_move_call_only,7},
	{put_list,8},
	{l_is_eq_exact_immed,22},
	{is_nonempty_list_test_heap,0},
	{is_tuple,4},
	{extract_next_element2,9},
	{case_end,4},
	{l_is_function2,0},
	{bif2_body,3},
	{fmove_2,1},
	{l_call_ext,22},
	{extract_next_element,16},
	{extract_next_element2,10},
	{move_jump,2},
	{move_return,8},
	{is_nonempty_list,17},
	{is_pid,0},
	{l_jump_on_val,0},
	{l_get,3},
	{bif1_body,3},
	{l_select_val2,11},
	{l_allocate_zero,8},
	{is_list,4},
	{l_is_ne_exact_immed,4},
	{fmove_1,2},
	{bif1_body,4},
	{fmove_1,1},
	{is_nonempty_list,18},
	{l_bs_test_unit_8,3},
	{l_fetch,15},
	{l_is_eq_exact_immed,24},
	{put_list,10},
	{call_bif,38},
	{l_gc_bif1,4},
	{extract_next_element,17},
	{is_atom,6},
	{l_move_call,15},
	{l_allocate,10},
	{l_move_call_ext_last,3},
	{l_call_ext,23},
	{l_element,1},
	{move_deallocate_return,8},
	{l_new_bs_put_integer,0},
	{l_call_ext,24},
	{l_move_call_last,5},
	{l_move_call_ext,25},
	{init,9},
	{l_allocate,8},
	{l_call_ext,25},
	{l_fdiv,0},
	{bs_context_to_binary,4},
	{l_bif2,6},
	{l_call_ext_last,6},
	{get_list,8},
	{node,4},
	{l_call_ext,26},
	{extract_next_element,18},
	{deallocate_return,9},
	{l_move_call_ext,15},
	{is_binary,3},
	{move_deallocate_return,9},
	{l_call_ext,27},
	{is_nonempty_list,19},
	{l_select_val_atoms,2},
	{badmatch,17},
	{call_bif,39},
	{l_call_ext,28},
	{extract_next_element2,11},
	{badmatch,5},
	{case_end,5},
	{l_bs_restore2,2},
	{l_fetch,16},
	{l_bs_get_integer,0},
	{l_is_eq_exact_immed,25},
	{l_call_ext,29},
	{move_return,9},
	{is_function,2},
	{l_bif1,2},
	{l_move_call_ext,26},
	{call_bif,40},
	{l_call_ext,30},
	{case_end,6},
	{l_move_call_ext,27},
	{catch_end,5},
	{l_bs_get_binary_imm2,0},
	{l_move_call_ext,28},
	{call_bif,42},
	{call_bif,41},
	{l_call_ext,32},
	{l_call_ext,31},
	{l_bs_test_unit_8,1},
	{l_move_call,16},
	{l_bsr,1},
	{l_move_call_ext,29},
	{l_bs_skip_bits_imm2,0},
	{l_move_call_ext,30},
	{l_call_ext,34},
	{l_call_ext,33},
	{is_nil,15},
	{is_nil,14},
	{badmatch,6},
	{l_call_last,11},
	{fconv,1},
	{is_boolean,0},
	{l_is_ne_exact_immed,5},
	{call_bif,43},
	{l_call_ext,35},
	{is_nil,16},
	{l_move_call_only,8},
	{l_bs_test_unit_8,2},
	{catch_end,7},
	{l_bs_get_utf16,1},
	{get_list,9},
	{l_plus,2},
	{deallocate_return,12},
	{l_element,3},
	{move_jump,3},
	{l_bs_put_string,0},
	{is_pid,1},
	{is_atom,4},
	{l_select_tuple_arity,2},
	{l_call_ext,36},
	{extract_next_element,19},
	{case_end,7},
	{l_catch,6},
	{l_call_ext,38},
	{l_call_ext,37},
	{move_jump,4},
	{is_nil,17},
	{is_list,5},
	{try_case_end,0},
	{l_bs_get_binary_all2,1},
	{move,11},
	{l_move_call_last,6},
	{put_list,14},
	{move_jump,5},
	{move_return,10},
	{l_is_eq_exact_literal,5},
	{bif2_body,2},
	{get_tuple_element,9},
	{put_list,11},
	{l_select_val2,12},
	{call_bif,44},
	{is_nonempty_list,20},
	{l_fsub,0},
	{l_move_call_ext,31},
	{bif1_body,5},
	{l_call_ext,39},
	{extract_next_element3,7},
	{l_bs_start_match2,3},
	{l_trim,8},
	{bs_context_to_binary,1},
	{l_call_ext,40},
	{move_return,11},
	{l_call_fun,4},
	{l_is_eq_exact_literal,6},
	{l_is_ne_exact_immed,6},
	{test_heap_1_put_list,2},
	{test_heap_1_put_list,3},
	{l_is_eq_exact_immed,26},
	{self,3},
	{l_call_ext,41},
	{l_move_call_ext,33},
	{init,10},
	{l_bs_skip_bits_imm2,1},
	{l_call_ext,42},
	{extract_next_element2,12},
	{badmatch,7},
	{l_move_call_ext_only,5},
	{l_call_ext,43},
	{move_jump,6},
	{is_nil,18},
	{l_call_ext_only,0},
	{l_fetch,17},
	{l_move_call_ext,34},
	{l_move_call_ext,35},
	{l_is_eq_exact_immed,27},
	{l_bs_append,1},
	{l_bif2,5},
	{l_bs_get_binary2,1},
	{l_bs_get_integer_small_imm,1},
	{l_call_ext,47},
	{l_call_ext,46},
	{l_call_ext,45},
	{l_call_ext,44},
	{move_return,12},
	{l_bs_save2,1},
	{is_function,0},
	{l_bs_get_integer_imm,0},
	{l_move_call_ext_only,6},
	{l_call_ext,48},
	{l_move_call,17},
	{l_is_ne_exact_immed,7},
	{l_call_ext,50},
	{l_call_ext,49},
	{is_integer,5},
	{move_return,13},
	{l_bs_put_string,1},
	{try_end,7},
	{l_yield,0},
	{l_move_call,18},
	{l_fetch,18},
	{l_is_eq_exact_immed,28},
	{l_new_bs_put_integer,1},
	{node,2},
	{l_call_ext,51},
	{move_jump,7},
	{case_end,9},
	{case_end,8},
	{is_nonempty_list,22},
	{is_nonempty_list,21},
	{l_move_call,19},
	{l_move_call_ext,37},
	{get_list,11},
	{l_fetch,19},
	{l_new_bs_put_float_imm,1},
	{l_move_call,20},
	{l_call_ext_only,1},
	{l_gc_bif1,6},
	{l_bif1,1},
	{l_move_call,21},
	{l_is_ne_exact_literal,0},
	{l_bs_put_string,2},
	{l_call_ext,52},
	{l_is_eq_exact_immed,23},
	{extract_next_element,20},
	{is_nil,19},
	{badmatch,8},
	{catch_end,6},
	{l_is_function2,1},
	{l_call_ext,53},
	{move_return,14},
	{badmatch,9},
	{self,4},
	{l_call_ext,56},
	{l_call_ext,55},
	{l_call_ext,54},
	{l_call_ext_last,5},
	{l_move_call,23},
	{l_move_call,22},
	{l_select_tuple_arity,3},
	{l_apply,0},
	{init,16},
	{init,11},
	{l_move_call_last,8},
	{l_move_call_last,7},
	{l_call_ext,59},
	{l_call_ext,58},
	{l_call_ext,57},
	{extract_next_element2,13},
	{l_new_bs_put_integer_imm,1},
	{try_end,6},
	{deallocate_return,10},
	{l_move_call,24},
	{l_fetch,20},
	{get_list,10},
	{l_allocate,9},
	{bs_init_writable,0},
	{l_call_ext,60},
	{extract_next_element,21},
	{extract_next_element3,8},
	{is_integer,6},
	{move_jump,8},
	{badmatch,10},
	{is_nonempty_list,23},
	{l_bs_private_append,0},
	{deallocate_return,11},
	{l_move_call,25},
	{l_call_ext,63},
	{l_call_ext,62},
	{l_call_ext,61},
	{move_jump,9},
	{move_return,16},
	{move_return,15},
	{bs_context_to_binary,2},
	{l_jump_on_val,1},
	{l_increment,7},
	{l_is_ne_exact_immed,8},
	{l_call_ext,67},
	{l_call_ext,66},
	{l_call_ext,65},
	{l_call_ext,64},
	{extract_next_element2,14},
	{put_list,13},
	{is_float,0},
	{l_is_eq_exact_immed,29},
	{l_select_val2,14},
	{l_call_ext,69},
	{l_call_ext,68},
	{extract_next_element3,9},
	{move_return,17},
	{is_nonempty_list,25},
	{is_nonempty_list,24},
	{l_select_tuple_arity2,2},
	{is_atom,5},
	{l_call_ext_only,2},
	{l_is_ne_exact_immed,9},
	{node,3},
	{is_tuple,5},
	{l_call_ext,73},
	{l_call_ext,72},
	{l_call_ext,71},
	{l_call_ext,70},
	{extract_next_element,22},
	{wait_timeout,0},
	{extract_next_element2,15},
	{is_nil,20},
	{is_nonempty_list,26},
	{l_wait_timeout,2},
	{l_minus,2},
	{is_tuple,6},
	{l_call_ext,79},
	{l_call_ext,78},
	{l_call_ext,77},
	{l_call_ext,76},
	{l_call_ext,75},
	{l_call_ext,74},
	{l_call_last,10},
	{l_bs_test_tail_imm2,0},
	{move_jump,10},
	{move_return,18},
	{is_integer_allocate,1},
	{is_nonempty_list,27},
	{l_new_bs_put_float_imm,0},
	{l_fetch,21},
	{move,12},
	{move2,9},
	{l_bs_skip_bits_all2,1},
	{is_tuple,7},
	{l_call_ext,84},
	{l_call_ext,83},
	{l_call_ext,82},
	{l_call_ext,81},
	{l_call_ext,80},
	{l_is_eq_exact_immed,30},
	{is_nil,21},
	{recv_mark,0},
	{raise,1},
	{case_end,10},
	{is_function,1},
	{l_call_ext_only,3},
	{l_recv_set,0},
	{l_bs_skip_bits_all2,2},
	{l_fast_element,3},
	{l_trim,11},
	{l_times,2},
	{bs_context_to_binary,3},
	{l_move_call_ext,32},
	{l_is_eq_exact_immed,31},
	{is_port,0},
	{l_bs_get_float2,0},
	{l_bs_get_utf8,1},
	{l_select_val2,15},
	{l_select_tuple_arity,4},
	{test_heap_1_put_list,4},
	{is_map,0},
	{l_trim,9},
	{badmatch,11},
	{l_apply_fun,0},
	{init,12},
	{l_is_eq_exact_immed,32},
	{extract_next_element,23},
	{l_move_call_only,10},
	{l_move_call_only,9},
	{l_is_eq_exact_immed,33},
	{l_is_ne_exact_immed,10},
	{move_return,19},
	{badmatch,13},
	{badmatch,12},
	{l_bs_get_integer_16,0},
	{l_bs_get_binary_all_reuse,1},
	{l_is_eq_exact_immed,34},
	{move_jump,11},
	{move_return,21},
	{move_return,20},
	{l_move_call_only,11},
	{badmatch,14},
	{is_list,6},
	{l_bs_init_fail,1},
	{l_move_call_ext,36},
	{is_tuple,8},
	{move_jump,13},
	{move_jump,12},
	{move_return,22},
	{is_nil,22},
	{is_nonempty_list,29},
	{is_nonempty_list,28},
	{l_bs_init,0},
	{l_bs_restore2,3},
	{move,13},
	{l_bs_get_binary_imm2,1},
	{is_nonempty_list,30},
	{l_bs_init_bits,0},
	{l_bs_put_utf16,0},
	{is_bitstr,0},
	{l_bs_validate_unicode,0},
	{is_nonempty_list,32},
	{is_nonempty_list,31},
	{l_bs_save2,2},
	{l_bs_utf16_size,0},
	{l_bs_get_binary2,2},
	{l_is_eq_exact_immed,35},
	{get_tuple_element,10},
	{l_bs_get_integer_32,2},
	{move_return,24},
	{move_return,23},
	{is_nil,23},
	{badmatch,15},
	{is_nonempty_list,33},
	{move,14},
	{l_bs_add,1},
	{is_reference,0},
	{is_nil,26},
	{is_nil,25},
	{is_nil,24},
	{l_new_bs_put_binary,0},
	{badmatch,16},
	{is_nonempty_list,34},
	{init,13},
	{is_nil,28},
	{is_nil,27},
	{put_list,12},
	{is_nonempty_list,35},
	{l_bs_validate_unicode_retract,0},
	{l_wait_timeout,0},
	{l_gc_bif2,0},
	{init,14},
	{l_fast_element,4},
	{l_trim,10},
	{l_new_bs_put_binary_all,1},
	{l_apply_last,0},
	{init,15},
	{is_number,0},
	{l_int_bnot,0},
	{l_bs_put_utf8,0},
	{l_new_bs_put_float,0},
	{l_select_val2,13},
	{l_bs_utf8_size,0},
	{l_wait_timeout,1},
	{fmove_2,2},
	{l_jump_on_val,2},
	{l_bs_get_binary_imm2,2},
	{l_fnegate,0},
	{get_list,12},
	{l_bs_get_integer_imm,1},
	{bif1_body,6},
	{l_bs_get_binary_all_reuse,2},
	{l_bxor,0},
	{l_new_bs_put_integer_imm,2},
	{l_int_div,2},
	{l_gc_bif3,0},
	{l_apply_only,0},
	{l_bor,2},
	{l_bs_start_match2,4},
	{l_rem,2},
	{l_bsl,2},
	{l_new_bs_put_binary_imm,0},
	{l_apply_fun_only,0},
	{l_bs_get_integer_8,2},
	{l_bs_get_integer_small_imm,2},
	{l_hibernate,0},
	{l_apply_fun_last,0},
	{l_band,2},
	{is_bigint,0},
	{on_load,0},
	{move2,10},
	{l_bs_test_unit,0},
	{l_m_div,0},
	{l_select_val_smallints,2},
	{is_function2,0},
	{test_heap,1},
	{func_info,0},
	{call_bif,0},
	{l_bs_get_utf16,2},
	{l_put_tuple,7},
	{allocate_init,1},
	{l_call_fun_last,1},
	{set_tuple_element,2},
	{allocate_heap,1},
	{is_tuple_of_arity,4},
	{test_arity,4},
	{l_bs_match_string,4},
	{is_nonempty_list_allocate,2},
	{l_bs_append,2},
	{try_case_end,1},
	{init3,1},
	{l_select_tuple_arity2,3},
	{init2,1},
	{l_is_function2,2},
	{l_bs_get_binary_all2,2},
	{is_nonempty_list_test_heap,1},
	{allocate_heap_zero,1},
	{l_bs_init_heap_bin,1},
	{l_plus,3},
	{l_bs_get_integer,1}

].


fit_args(allocate_heap, [NumSlots,HeapNeeded,Live]) when NumSlots >= 0, NumSlots =< 255, HeapNeeded >= 0, HeapNeeded =< 255, Live >= 0, Live =< 255 -> 0;
fit_args(allocate_heap, [_,_,Live]) when Live >= 0, Live =< 255 -> 1;
fit_args(allocate_heap_zero, [NumSlots,HeapNeeded,Live]) when NumSlots >= 0, NumSlots =< 255, HeapNeeded >= 0, HeapNeeded =< 255, Live >= 0, Live =< 255 -> 0;
fit_args(allocate_heap_zero, [_,_,Live]) when Live >= 0, Live =< 255 -> 1;
fit_args(allocate_init, [_,{y,0}]) -> 0;
fit_args(allocate_init, [_,_]) -> 1;
fit_args(apply, [Arg0]) when Arg0 >= 0, Arg0 =< 255 -> 0;
fit_args(apply_last, [Arg0,_]) when Arg0 >= 0, Arg0 =< 255 -> 0;
fit_args(badmatch, [{x,0}]) -> 0;
fit_args(badmatch, [{x,3}]) -> 1;
fit_args(badmatch, [{x,2}]) -> 2;
fit_args(badmatch, [{x,1}]) -> 3;
fit_args(badmatch, [{y,2}]) -> 4;
fit_args(badmatch, [{y,3}]) -> 5;
fit_args(badmatch, [{x,4}]) -> 6;
fit_args(badmatch, [{y,4}]) -> 7;
fit_args(badmatch, [{x,5}]) -> 8;
fit_args(badmatch, [{y,0}]) -> 9;
fit_args(badmatch, [{x,7}]) -> 10;
fit_args(badmatch, [{y,6}]) -> 11;
fit_args(badmatch, [{y,9}]) -> 13;
fit_args(badmatch, [{y,5}]) -> 12;
fit_args(badmatch, [{y,1}]) -> 14;
fit_args(badmatch, [{x,6}]) -> 15;
fit_args(badmatch, [{y,8}]) -> 16;
fit_args(badmatch, [_]) -> 17;
fit_args(bif1_body, [{b,{erlang,hd,1}},{y,1},{x,2}]) -> 2;
fit_args(bif1_body, [{b,{erlang,hd,1}},_,{x,0}]) -> 0;
fit_args(bif1_body, [{b,_},{x,0},_]) -> 1;
fit_args(bif1_body, [{b,_},{y,Arg1},{x,_}]) when Arg1 >= 0, Arg1 =< 255 -> 4;
fit_args(bif1_body, [{b,_},{x,_},{x,_}]) -> 5;
fit_args(bif1_body, [{b,_},_,{x,0}]) -> 3;
fit_args(bif1_body, [{b,_},_,_]) -> 6;
fit_args(bif2_body, [{b,_},{x,0}]) -> 0;
fit_args(bif2_body, [{b,_},{x,1}]) -> 1;
fit_args(bif2_body, [{b,_},{x,2}]) -> 2;
fit_args(bif2_body, [{b,_},_]) -> 3;
fit_args(bs_context_to_binary, [{x,0}]) -> 0;
fit_args(bs_context_to_binary, [{x,1}]) -> 1;
fit_args(bs_context_to_binary, [{x,2}]) -> 2;
fit_args(bs_context_to_binary, [{y,0}]) -> 3;
fit_args(bs_context_to_binary, [_]) -> 4;
fit_args(bs_init_writable, []) -> 0;
fit_args(call_bif, [{b,{erlang,iolist_to_binary,1}}]) -> 7;
fit_args(call_bif, [{b,{erlang,error,1}}]) -> 3;
fit_args(call_bif, [{b,{erlang,setelement,3}}]) -> 8;
fit_args(call_bif, [{b,{erlang,'++',2}}]) -> 9;
fit_args(call_bif, [{b,{erlang,throw,1}}]) -> 6;
fit_args(call_bif, [{b,{erlang,error,2}}]) -> 2;
fit_args(call_bif, [{b,{erlang,exit,1}}]) -> 5;
fit_args(call_bif, [{b,{lists,member,2}}]) -> 10;
fit_args(call_bif, [{b,{ets,insert,2}}]) -> 11;
fit_args(call_bif, [{b,{erlang,get_module_info,2}}]) -> 12;
fit_args(call_bif, [{b,{erlang,binary_to_list,1}}]) -> 13;
fit_args(call_bif, [{b,{erlang,list_to_binary,1}}]) -> 14;
fit_args(call_bif, [{b,{ets,delete,1}}]) -> 15;
fit_args(call_bif, [{b,{lists,keysearch,3}}]) -> 16;
fit_args(call_bif, [{b,{ets,lookup,2}}]) -> 17;
fit_args(call_bif, [{b,{erlang,integer_to_list,1}}]) -> 19;
fit_args(call_bif, [{b,{lists,reverse,2}}]) -> 18;
fit_args(call_bif, [{b,{erlang,atom_to_list,1}}]) -> 20;
fit_args(call_bif, [{b,{erlang,list_to_atom,1}}]) -> 21;
fit_args(call_bif, [{b,{ets,info,2}}]) -> 22;
fit_args(call_bif, [{b,{erlang,tuple_to_list,1}}]) -> 23;
fit_args(call_bif, [{b,{erlang,list_to_tuple,1}}]) -> 24;
fit_args(call_bif, [{b,{erlang,'--',2}}]) -> 26;
fit_args(call_bif, [{b,{lists,keyfind,3}}]) -> 25;
fit_args(call_bif, [{b,{ets,lookup_element,3}}]) -> 27;
fit_args(call_bif, [{b,{erlang,process_flag,2}}]) -> 28;
fit_args(call_bif, [{b,{re,run,3}}]) -> 29;
fit_args(call_bif, [{b,{erlang,raise,3}}]) -> 1;
fit_args(call_bif, [{b,{ets,new,2}}]) -> 30;
fit_args(call_bif, [{b,{erlang,make_ref,0}}]) -> 32;
fit_args(call_bif, [{b,{erlang,whereis,1}}]) -> 31;
fit_args(call_bif, [{b,{erlang,process_info,2}}]) -> 33;
fit_args(call_bif, [{b,{erlang,unlink,1}}]) -> 34;
fit_args(call_bif, [{b,{erlang,exit,2}}]) -> 4;
fit_args(call_bif, [{b,{erlang,get_stacktrace,0}}]) -> 35;
fit_args(call_bif, [{b,{ets,delete,2}}]) -> 36;
fit_args(call_bif, [{b,{lists,keymember,3}}]) -> 37;
fit_args(call_bif, [{b,{erlang,now,0}}]) -> 38;
fit_args(call_bif, [{b,{erlang,spawn_link,1}}]) -> 39;
fit_args(call_bif, [{b,{ets,safe_fixtable,2}}]) -> 40;
fit_args(call_bif, [{b,{ets,next,2}}]) -> 42;
fit_args(call_bif, [{b,{erlang,fun_info,2}}]) -> 41;
fit_args(call_bif, [{b,{erlang,monitor,2}}]) -> 43;
fit_args(call_bif, [{b,{ets,match_object,2}}]) -> 44;
fit_args(call_bif, [{b,{erlang,purge_module,1}}]) -> 0;
fit_args(call_bif, [{b,_}]) -> 45;
fit_args(case_end, [{x,0}]) -> 0;
fit_args(case_end, [{x,1}]) -> 1;
fit_args(case_end, [{x,2}]) -> 2;
fit_args(case_end, [{x,3}]) -> 3;
fit_args(case_end, [{y,2}]) -> 4;
fit_args(case_end, [{y,1}]) -> 5;
fit_args(case_end, [{x,4}]) -> 6;
fit_args(case_end, [{y,3}]) -> 7;
fit_args(case_end, [{y,4}]) -> 9;
fit_args(case_end, [{y,0}]) -> 8;
fit_args(case_end, [{x,5}]) -> 10;
fit_args(case_end, [_]) -> 11;
fit_args(catch_end, [{y,0}]) -> 0;
fit_args(catch_end, [{y,1}]) -> 1;
fit_args(catch_end, [{y,2}]) -> 2;
fit_args(catch_end, [{y,3}]) -> 3;
fit_args(catch_end, [{y,4}]) -> 4;
fit_args(catch_end, [{y,5}]) -> 5;
fit_args(catch_end, [{y,6}]) -> 6;
fit_args(catch_end, [_]) -> 7;
fit_args(deallocate_return, [1]) -> 0;
fit_args(deallocate_return, [0]) -> 1;
fit_args(deallocate_return, [2]) -> 2;
fit_args(deallocate_return, [3]) -> 3;
fit_args(deallocate_return, [4]) -> 4;
fit_args(deallocate_return, [5]) -> 5;
fit_args(deallocate_return, [6]) -> 6;
fit_args(deallocate_return, [7]) -> 7;
fit_args(deallocate_return, [8]) -> 8;
fit_args(deallocate_return, [9]) -> 9;
fit_args(deallocate_return, [10]) -> 10;
fit_args(deallocate_return, [11]) -> 11;
fit_args(deallocate_return, [_]) -> 12;
fit_args(extract_next_element, [{x,1}]) -> 0;
fit_args(extract_next_element, [{x,3}]) -> 1;
fit_args(extract_next_element, [{x,2}]) -> 2;
fit_args(extract_next_element, [{x,4}]) -> 3;
fit_args(extract_next_element, [{x,5}]) -> 4;
fit_args(extract_next_element, [{x,6}]) -> 5;
fit_args(extract_next_element, [{x,255}]) -> 6;
fit_args(extract_next_element, [{x,7}]) -> 7;
fit_args(extract_next_element, [{y,1}]) -> 8;
fit_args(extract_next_element, [{y,0}]) -> 9;
fit_args(extract_next_element, [{x,8}]) -> 10;
fit_args(extract_next_element, [{x,9}]) -> 11;
fit_args(extract_next_element, [{y,2}]) -> 12;
fit_args(extract_next_element, [{y,3}]) -> 13;
fit_args(extract_next_element, [{x,10}]) -> 14;
fit_args(extract_next_element, [{x,11}]) -> 15;
fit_args(extract_next_element, [{y,5}]) -> 16;
fit_args(extract_next_element, [{y,4}]) -> 17;
fit_args(extract_next_element, [{x,12}]) -> 18;
fit_args(extract_next_element, [{x,13}]) -> 19;
fit_args(extract_next_element, [{x,14}]) -> 20;
fit_args(extract_next_element, [{x,16}]) -> 21;
fit_args(extract_next_element, [{y,6}]) -> 22;
fit_args(extract_next_element, [{x,18}]) -> 23;
fit_args(extract_next_element, [_]) -> 24;
fit_args(extract_next_element2, [{x,1}]) -> 0;
fit_args(extract_next_element2, [{x,3}]) -> 1;
fit_args(extract_next_element2, [{x,2}]) -> 2;
fit_args(extract_next_element2, [{x,4}]) -> 3;
fit_args(extract_next_element2, [{x,5}]) -> 4;
fit_args(extract_next_element2, [{x,6}]) -> 5;
fit_args(extract_next_element2, [{x,7}]) -> 6;
fit_args(extract_next_element2, [{x,8}]) -> 7;
fit_args(extract_next_element2, [{x,9}]) -> 8;
fit_args(extract_next_element2, [{x,12}]) -> 9;
fit_args(extract_next_element2, [{x,10}]) -> 10;
fit_args(extract_next_element2, [{x,11}]) -> 11;
fit_args(extract_next_element2, [{x,13}]) -> 12;
fit_args(extract_next_element2, [{x,14}]) -> 13;
fit_args(extract_next_element2, [{y,0}]) -> 14;
fit_args(extract_next_element2, [{x,16}]) -> 15;
fit_args(extract_next_element2, [_]) -> 16;
fit_args(extract_next_element3, [{x,1}]) -> 0;
fit_args(extract_next_element3, [{x,3}]) -> 1;
fit_args(extract_next_element3, [{x,2}]) -> 2;
fit_args(extract_next_element3, [{x,5}]) -> 3;
fit_args(extract_next_element3, [{x,4}]) -> 4;
fit_args(extract_next_element3, [{x,6}]) -> 5;
fit_args(extract_next_element3, [{x,7}]) -> 6;
fit_args(extract_next_element3, [{x,8}]) -> 7;
fit_args(extract_next_element3, [{x,11}]) -> 8;
fit_args(extract_next_element3, [{x,10}]) -> 9;
fit_args(extract_next_element3, [_]) -> 10;
fit_args(fclearerror, []) -> 0;
fit_args(fconv, [_,{fr,0}]) -> 0;
fit_args(fconv, [_,{fr,_}]) -> 1;
fit_args(fmove_1, [{x,_},{fr,_}]) -> 1;
fit_args(fmove_1, [_,{fr,1}]) -> 0;
fit_args(fmove_1, [_,{fr,_}]) -> 2;
fit_args(fmove_2, [{fr,_},{x,0}]) -> 0;
fit_args(fmove_2, [{fr,_},{x,_}]) -> 1;
fit_args(fmove_2, [{fr,_},_]) -> 2;
fit_args(func_info, [_,_,Arg2]) when Arg2 >= 0, Arg2 =< 255 -> 0;
fit_args(get_list, [{x,0},{x,0},_]) -> 3;
fit_args(get_list, [{x,0},{x,_},{x,_}]) -> 1;
fit_args(get_list, [{x,0},{y,Arg1},{y,Arg2}]) when Arg1 >= 0, Arg1 =< 255, Arg2 >= 0, Arg2 =< 255 -> 9;
fit_args(get_list, [{x,0},_,{x,0}]) -> 5;
fit_args(get_list, [{x,_},{x,0},{x,_}]) -> 2;
fit_args(get_list, [{x,_},{x,_},{x,_}]) -> 0;
fit_args(get_list, [{y,Arg0},{x,_},{x,_}]) when Arg0 >= 0, Arg0 =< 255 -> 6;
fit_args(get_list, [{x,_},{y,Arg1},{y,Arg2}]) when Arg1 >= 0, Arg1 =< 255, Arg2 >= 0, Arg2 =< 255 -> 8;
fit_args(get_list, [{x,_},{y,Arg1},{x,_}]) when Arg1 >= 0, Arg1 =< 255 -> 10;
fit_args(get_list, [_,{x,0},_]) -> 7;
fit_args(get_list, [_,{x,_},{y,Arg2}]) when Arg2 >= 0, Arg2 =< 255 -> 4;
fit_args(get_list, [_,_,{x,0}]) -> 11;
fit_args(get_list, [_,_,_]) -> 12;
fit_args(get_tuple_element, [{x,0},1,{x,0}]) -> 6;
fit_args(get_tuple_element, [{x,0},Arg1,{x,_}]) when Arg1 >= 0, Arg1 =< 255 -> 0;
fit_args(get_tuple_element, [{x,0},Arg1,{y,Arg2}]) when Arg1 >= 0, Arg1 =< 255, Arg2 >= 0, Arg2 =< 255 -> 3;
fit_args(get_tuple_element, [{x,0},_,{x,0}]) -> 8;
fit_args(get_tuple_element, [{x,_},Arg1,{x,0}]) when Arg1 >= 0, Arg1 =< 255 -> 7;
fit_args(get_tuple_element, [{y,Arg0},Arg1,{x,0}]) when Arg0 >= 0, Arg0 =< 255, Arg1 >= 0, Arg1 =< 255 -> 9;
fit_args(get_tuple_element, [{x,_},Arg1,{x,_}]) when Arg1 >= 0, Arg1 =< 255 -> 1;
fit_args(get_tuple_element, [{y,Arg0},Arg1,{x,_}]) when Arg0 >= 0, Arg0 =< 255, Arg1 >= 0, Arg1 =< 255 -> 4;
fit_args(get_tuple_element, [{x,_},Arg1,{y,Arg2}]) when Arg1 >= 0, Arg1 =< 255, Arg2 >= 0, Arg2 =< 255 -> 5;
fit_args(get_tuple_element, [_,0,{x,0}]) -> 2;
fit_args(get_tuple_element, [_,_,_]) -> 10;
fit_args(if_end, []) -> 0;
fit_args(init, [{y,1}]) -> 0;
fit_args(init, [{y,0}]) -> 1;
fit_args(init, [{y,2}]) -> 2;
fit_args(init, [{y,3}]) -> 3;
fit_args(init, [{y,4}]) -> 4;
fit_args(init, [{y,5}]) -> 5;
fit_args(init, [{y,6}]) -> 6;
fit_args(init, [{y,7}]) -> 7;
fit_args(init, [{y,8}]) -> 8;
fit_args(init, [{y,9}]) -> 9;
fit_args(init, [{y,10}]) -> 10;
fit_args(init, [{y,11}]) -> 11;
fit_args(init, [{y,12}]) -> 12;
fit_args(init, [{y,14}]) -> 13;
fit_args(init, [{y,13}]) -> 14;
fit_args(init, [{y,16}]) -> 15;
fit_args(init, [_]) -> 16;
fit_args(init2, [{y,Arg0},{y,Arg1}]) when Arg0 >= 0, Arg0 =< 255, Arg1 >= 0, Arg1 =< 255 -> 0;
fit_args(init2, [_,_]) -> 1;
fit_args(init3, [{y,Arg0},{y,Arg1},{y,Arg2}]) when Arg0 >= 0, Arg0 =< 255, Arg1 >= 0, Arg1 =< 255, Arg2 >= 0, Arg2 =< 255 -> 0;
fit_args(init3, [_,_,_]) -> 1;
fit_args(int_code_end, []) -> 0;
fit_args(is_atom, [{f,_},{x,0}]) -> 0;
fit_args(is_atom, [{f,_},{x,1}]) -> 1;
fit_args(is_atom, [{f,_},{x,2}]) -> 2;
fit_args(is_atom, [{f,_},{x,3}]) -> 3;
fit_args(is_atom, [{f,_},{x,4}]) -> 4;
fit_args(is_atom, [{f,_},{x,5}]) -> 5;
fit_args(is_atom, [{f,_},_]) -> 6;
fit_args(is_bigint, [{f,_},_]) -> 0;
fit_args(is_binary, [{f,_},{x,0}]) -> 0;
fit_args(is_binary, [{f,_},{x,1}]) -> 1;
fit_args(is_binary, [{f,_},{x,2}]) -> 2;
fit_args(is_binary, [{f,_},_]) -> 3;
fit_args(is_bitstr, [{f,_},_]) -> 0;
fit_args(is_boolean, [{f,_},_]) -> 0;
fit_args(is_float, [{f,_},{x,0}]) -> 0;
fit_args(is_float, [{f,_},_]) -> 1;
fit_args(is_function, [{f,_},{x,0}]) -> 0;
fit_args(is_function, [{f,_},{x,1}]) -> 1;
fit_args(is_function, [{f,_},_]) -> 2;
fit_args(is_function2, [{f,_},_,_]) -> 0;
fit_args(is_integer, [{f,_},{x,0}]) -> 0;
fit_args(is_integer, [{f,_},{x,1}]) -> 1;
fit_args(is_integer, [{f,_},{x,2}]) -> 2;
fit_args(is_integer, [{f,_},{x,3}]) -> 3;
fit_args(is_integer, [{f,_},{x,4}]) -> 4;
fit_args(is_integer, [{f,_},{x,5}]) -> 5;
fit_args(is_integer, [{f,_},{x,6}]) -> 6;
fit_args(is_integer, [{f,_},_]) -> 7;
fit_args(is_integer_allocate, [{f,_},{x,_},Arg2]) when Arg2 >= 0, Arg2 =< 255 -> 0;
fit_args(is_integer_allocate, [{f,_},_,_]) -> 1;
fit_args(is_list, [{f,_},{x,0}]) -> 0;
fit_args(is_list, [{f,_},{x,1}]) -> 1;
fit_args(is_list, [{f,_},{x,2}]) -> 2;
fit_args(is_list, [{f,_},{x,3}]) -> 3;
fit_args(is_list, [{f,_},{x,4}]) -> 4;
fit_args(is_list, [{f,_},{x,5}]) -> 5;
fit_args(is_list, [{f,_},{x,7}]) -> 6;
fit_args(is_list, [{f,_},_]) -> 7;
fit_args(is_map, [{f,_},_]) -> 0;
fit_args(is_nil, [{f,_},{x,0}]) -> 0;
fit_args(is_nil, [{f,_},{x,2}]) -> 1;
fit_args(is_nil, [{f,_},{x,1}]) -> 2;
fit_args(is_nil, [{f,_},{x,4}]) -> 3;
fit_args(is_nil, [{f,_},{x,3}]) -> 4;
fit_args(is_nil, [{f,_},{x,5}]) -> 5;
fit_args(is_nil, [{f,_},{x,6}]) -> 6;
fit_args(is_nil, [{f,_},{x,7}]) -> 7;
fit_args(is_nil, [{f,_},{x,8}]) -> 8;
fit_args(is_nil, [{f,_},{x,9}]) -> 9;
fit_args(is_nil, [{f,_},{x,10}]) -> 10;
fit_args(is_nil, [{f,_},{x,12}]) -> 11;
fit_args(is_nil, [{f,_},{x,11}]) -> 12;
fit_args(is_nil, [{f,_},{y,1}]) -> 13;
fit_args(is_nil, [{f,_},{y,2}]) -> 15;
fit_args(is_nil, [{f,_},{x,13}]) -> 14;
fit_args(is_nil, [{f,_},{x,15}]) -> 16;
fit_args(is_nil, [{f,_},{x,14}]) -> 17;
fit_args(is_nil, [{f,_},{x,16}]) -> 18;
fit_args(is_nil, [{f,_},{y,3}]) -> 19;
fit_args(is_nil, [{f,_},{x,17}]) -> 20;
fit_args(is_nil, [{f,_},{y,0}]) -> 21;
fit_args(is_nil, [{f,_},{x,19}]) -> 22;
fit_args(is_nil, [{f,_},{x,18}]) -> 23;
fit_args(is_nil, [{f,_},{x,22}]) -> 26;
fit_args(is_nil, [{f,_},{x,21}]) -> 25;
fit_args(is_nil, [{f,_},{y,4}]) -> 24;
fit_args(is_nil, [{f,_},{x,20}]) -> 28;
fit_args(is_nil, [{f,_},{y,5}]) -> 27;
fit_args(is_nil, [{f,_},_]) -> 29;
fit_args(is_nonempty_list, [{f,_},{x,0}]) -> 0;
fit_args(is_nonempty_list, [{f,_},{x,2}]) -> 1;
fit_args(is_nonempty_list, [{f,_},{x,1}]) -> 2;
fit_args(is_nonempty_list, [{f,_},{x,3}]) -> 3;
fit_args(is_nonempty_list, [{f,_},{x,7}]) -> 4;
fit_args(is_nonempty_list, [{f,_},{x,4}]) -> 5;
fit_args(is_nonempty_list, [{f,_},{x,5}]) -> 6;
fit_args(is_nonempty_list, [{f,_},{x,6}]) -> 7;
fit_args(is_nonempty_list, [{f,_},{x,9}]) -> 8;
fit_args(is_nonempty_list, [{f,_},{x,8}]) -> 9;
fit_args(is_nonempty_list, [{f,_},{x,10}]) -> 10;
fit_args(is_nonempty_list, [{f,_},{x,11}]) -> 11;
fit_args(is_nonempty_list, [{f,_},{x,12}]) -> 12;
fit_args(is_nonempty_list, [{f,_},{x,13}]) -> 13;
fit_args(is_nonempty_list, [{f,_},{y,2}]) -> 14;
fit_args(is_nonempty_list, [{f,_},{y,3}]) -> 15;
fit_args(is_nonempty_list, [{f,_},{x,14}]) -> 16;
fit_args(is_nonempty_list, [{f,_},{y,1}]) -> 17;
fit_args(is_nonempty_list, [{f,_},{x,15}]) -> 18;
fit_args(is_nonempty_list, [{f,_},{x,16}]) -> 19;
fit_args(is_nonempty_list, [{f,_},{x,17}]) -> 20;
fit_args(is_nonempty_list, [{f,_},{y,4}]) -> 22;
fit_args(is_nonempty_list, [{f,_},{x,18}]) -> 21;
fit_args(is_nonempty_list, [{f,_},{x,20}]) -> 23;
fit_args(is_nonempty_list, [{f,_},{y,0}]) -> 25;
fit_args(is_nonempty_list, [{f,_},{x,19}]) -> 24;
fit_args(is_nonempty_list, [{f,_},{y,6}]) -> 26;
fit_args(is_nonempty_list, [{f,_},{y,9}]) -> 27;
fit_args(is_nonempty_list, [{f,_},{y,7}]) -> 29;
fit_args(is_nonempty_list, [{f,_},{y,5}]) -> 28;
fit_args(is_nonempty_list, [{f,_},{x,24}]) -> 30;
fit_args(is_nonempty_list, [{f,_},{y,8}]) -> 32;
fit_args(is_nonempty_list, [{f,_},{x,21}]) -> 31;
fit_args(is_nonempty_list, [{f,_},{x,22}]) -> 33;
fit_args(is_nonempty_list, [{f,_},{x,25}]) -> 34;
fit_args(is_nonempty_list, [{f,_},{x,26}]) -> 35;
fit_args(is_nonempty_list, [{f,_},_]) -> 36;
fit_args(is_nonempty_list_allocate, [{f,_},{x,0},_]) -> 0;
fit_args(is_nonempty_list_allocate, [{f,_},{x,_},Arg2]) when Arg2 >= 0, Arg2 =< 255 -> 1;
fit_args(is_nonempty_list_allocate, [{f,_},_,_]) -> 2;
fit_args(is_nonempty_list_test_heap, [{f,_},Arg1,Arg2]) when Arg1 >= 0, Arg1 =< 255, Arg2 >= 0, Arg2 =< 255 -> 0;
fit_args(is_nonempty_list_test_heap, [{f,_},_,Arg2]) when Arg2 >= 0, Arg2 =< 255 -> 1;
fit_args(is_number, [{f,_},_]) -> 0;
fit_args(is_pid, [{f,_},{x,0}]) -> 0;
fit_args(is_pid, [{f,_},_]) -> 1;
fit_args(is_port, [{f,_},_]) -> 0;
fit_args(is_reference, [{f,_},_]) -> 0;
fit_args(is_tuple, [{f,_},{x,0}]) -> 0;
fit_args(is_tuple, [{f,_},{x,1}]) -> 1;
fit_args(is_tuple, [{f,_},{x,2}]) -> 2;
fit_args(is_tuple, [{f,_},{x,3}]) -> 3;
fit_args(is_tuple, [{f,_},{x,4}]) -> 4;
fit_args(is_tuple, [{f,_},{x,7}]) -> 5;
fit_args(is_tuple, [{f,_},{x,5}]) -> 6;
fit_args(is_tuple, [{f,_},{y,4}]) -> 7;
fit_args(is_tuple, [{f,_},{x,6}]) -> 8;
fit_args(is_tuple, [{f,_},_]) -> 9;
fit_args(is_tuple_of_arity, [{f,_},{x,0},2]) -> 0;
fit_args(is_tuple_of_arity, [{f,_},{x,0},_]) -> 2;
fit_args(is_tuple_of_arity, [{f,_},{x,_},Arg2]) when Arg2 >= 0, Arg2 =< 255 -> 1;
fit_args(is_tuple_of_arity, [{f,_},{y,Arg1},Arg2]) when Arg1 >= 0, Arg1 =< 255, Arg2 >= 0, Arg2 =< 255 -> 3;
fit_args(is_tuple_of_arity, [{f,_},_,_]) -> 4;
fit_args(jump, [{f,_}]) -> 0;
fit_args(l_allocate, [1]) -> 0;
fit_args(l_allocate, [0]) -> 1;
fit_args(l_allocate, [2]) -> 2;
fit_args(l_allocate, [3]) -> 3;
fit_args(l_allocate, [4]) -> 4;
fit_args(l_allocate, [5]) -> 5;
fit_args(l_allocate, [6]) -> 6;
fit_args(l_allocate, [7]) -> 7;
fit_args(l_allocate, [8]) -> 8;
fit_args(l_allocate, [9]) -> 9;
fit_args(l_allocate, [_]) -> 10;
fit_args(l_allocate_zero, [2]) -> 0;
fit_args(l_allocate_zero, [1]) -> 1;
fit_args(l_allocate_zero, [3]) -> 2;
fit_args(l_allocate_zero, [4]) -> 3;
fit_args(l_allocate_zero, [6]) -> 4;
fit_args(l_allocate_zero, [5]) -> 5;
fit_args(l_allocate_zero, [7]) -> 6;
fit_args(l_allocate_zero, [8]) -> 7;
fit_args(l_allocate_zero, [9]) -> 8;
fit_args(l_allocate_zero, [_]) -> 9;
fit_args(l_apply, []) -> 0;
fit_args(l_apply_fun, []) -> 0;
fit_args(l_apply_fun_last, [_]) -> 0;
fit_args(l_apply_fun_only, []) -> 0;
fit_args(l_apply_last, [_]) -> 0;
fit_args(l_apply_only, []) -> 0;
fit_args(l_band, [{f,_},Arg1,{x,0}]) when Arg1 >= 0, Arg1 =< 255 -> 1;
fit_args(l_band, [{f,_},Arg1,{x,_}]) when Arg1 >= 0, Arg1 =< 255 -> 0;
fit_args(l_band, [{f,_},Arg1,_]) when Arg1 >= 0, Arg1 =< 255 -> 2;
fit_args(l_bif1, [{f,_},{b,{erlang,tuple_size,1}},{x,0},_]) -> 1;
fit_args(l_bif1, [{f,_},{b,_},{x,_},{x,_}]) -> 0;
fit_args(l_bif1, [{f,_},{b,_},_,_]) -> 2;
fit_args(l_bif2, [{f,_},{b,{erlang,element,2}},_]) -> 0;
fit_args(l_bif2, [{f,_},{b,{erlang,'=:=',2}},_]) -> 1;
fit_args(l_bif2, [{f,_},{b,{erlang,'=<',2}},_]) -> 2;
fit_args(l_bif2, [{f,_},{b,{erlang,'and',2}},_]) -> 3;
fit_args(l_bif2, [{f,_},{b,{erlang,'or',2}},_]) -> 4;
fit_args(l_bif2, [{f,_},{b,{erlang,'==',2}},_]) -> 5;
fit_args(l_bif2, [{f,_},{b,_},_]) -> 6;
fit_args(l_bor, [{f,_},Arg1,{x,0}]) when Arg1 >= 0, Arg1 =< 255 -> 0;
fit_args(l_bor, [{f,_},Arg1,{x,_}]) when Arg1 >= 0, Arg1 =< 255 -> 1;
fit_args(l_bor, [{f,_},Arg1,_]) when Arg1 >= 0, Arg1 =< 255 -> 2;
fit_args(l_bs_add, [{f,_},1,_]) -> 0;
fit_args(l_bs_add, [{f,_},Arg1,_]) when Arg1 >= 0, Arg1 =< 255 -> 1;
fit_args(l_bs_append, [{f,_},Arg1,Arg2,Arg3,{x,0}]) when Arg1 >= 0, Arg1 =< 255, Arg2 >= 0, Arg2 =< 255, Arg3 >= 0, Arg3 =< 255 -> 1;
fit_args(l_bs_append, [{f,_},Arg1,Arg2,Arg3,{x,_}]) when Arg1 >= 0, Arg1 =< 255, Arg2 >= 0, Arg2 =< 255, Arg3 >= 0, Arg3 =< 255 -> 0;
fit_args(l_bs_append, [{f,_},_,Arg2,Arg3,_]) when Arg2 >= 0, Arg2 =< 255, Arg3 >= 0, Arg3 =< 255 -> 2;
fit_args(l_bs_get_binary2, [{f,_},{x,_},Arg2,_,Arg4,0,{x,_}]) when Arg2 >= 0, Arg2 =< 255, Arg4 >= 0, Arg4 =< 255 -> 1;
fit_args(l_bs_get_binary2, [{f,_},_,Arg2,{x,_},Arg4,0,{x,_}]) when Arg2 >= 0, Arg2 =< 255, Arg4 >= 0, Arg4 =< 255 -> 0;
fit_args(l_bs_get_binary2, [{f,_},_,Arg2,_,Arg4,Arg5,_]) when Arg2 >= 0, Arg2 =< 255, Arg4 >= 0, Arg4 =< 255, Arg5 >= 0, Arg5 =< 255 -> 2;
fit_args(l_bs_get_binary_all2, [{f,_},{x,0},Arg2,Arg3,{x,_}]) when Arg2 >= 0, Arg2 =< 255, Arg3 >= 0, Arg3 =< 255 -> 1;
fit_args(l_bs_get_binary_all2, [{f,_},{x,_},Arg2,Arg3,{x,_}]) when Arg2 >= 0, Arg2 =< 255, Arg3 >= 0, Arg3 =< 255 -> 0;
fit_args(l_bs_get_binary_all2, [{f,_},_,Arg2,Arg3,_]) when Arg2 >= 0, Arg2 =< 255, Arg3 >= 0, Arg3 =< 255 -> 2;
fit_args(l_bs_get_binary_all_reuse, [{x,0},{f,_},1]) -> 1;
fit_args(l_bs_get_binary_all_reuse, [_,{f,_},8]) -> 0;
fit_args(l_bs_get_binary_all_reuse, [_,{f,_},Arg2]) when Arg2 >= 0, Arg2 =< 255 -> 2;
fit_args(l_bs_get_binary_imm2, [{f,_},{x,0},Arg2,_,Arg4,{x,_}]) when Arg2 >= 0, Arg2 =< 255, Arg4 >= 0, Arg4 =< 255 -> 1;
fit_args(l_bs_get_binary_imm2, [{f,_},{x,_},Arg2,Arg3,0,{x,_}]) when Arg2 >= 0, Arg2 =< 255, Arg3 >= 0, Arg3 =< 255 -> 0;
fit_args(l_bs_get_binary_imm2, [{f,_},_,Arg2,_,Arg4,_]) when Arg2 >= 0, Arg2 =< 255, Arg4 >= 0, Arg4 =< 255 -> 2;
fit_args(l_bs_get_float2, [{f,_},_,Arg2,_,Arg4,Arg5,_]) when Arg2 >= 0, Arg2 =< 255, Arg4 >= 0, Arg4 =< 255, Arg5 >= 0, Arg5 =< 255 -> 0;
fit_args(l_bs_get_integer, [{f,_},Arg1,Arg2,Arg3,{x,_}]) when Arg1 >= 0, Arg1 =< 255, Arg2 >= 0, Arg2 =< 255, Arg3 >= 0, Arg3 =< 255 -> 0;
fit_args(l_bs_get_integer, [{f,_},Arg1,Arg2,Arg3,_]) when Arg1 >= 0, Arg1 =< 255, Arg2 >= 0, Arg2 =< 255, Arg3 >= 0, Arg3 =< 255 -> 1;
fit_args(l_bs_get_integer_16, [_,{f,_},_]) -> 0;
fit_args(l_bs_get_integer_32, [{x,0},{f,_},Arg2,{x,_}]) when Arg2 >= 0, Arg2 =< 255 -> 1;
fit_args(l_bs_get_integer_32, [{x,_},{f,_},Arg2,{x,_}]) when Arg2 >= 0, Arg2 =< 255 -> 0;
fit_args(l_bs_get_integer_32, [_,{f,_},Arg2,_]) when Arg2 >= 0, Arg2 =< 255 -> 2;
fit_args(l_bs_get_integer_8, [{x,0},{f,_},{x,_}]) -> 0;
fit_args(l_bs_get_integer_8, [{x,_},{f,_},{x,_}]) -> 1;
fit_args(l_bs_get_integer_8, [_,{f,_},_]) -> 2;
fit_args(l_bs_get_integer_imm, [_,Arg1,Arg2,{f,_},Arg4,{x,_}]) when Arg1 >= 0, Arg1 =< 255, Arg2 >= 0, Arg2 =< 255, Arg4 >= 0, Arg4 =< 255 -> 0;
fit_args(l_bs_get_integer_imm, [_,_,Arg2,{f,_},Arg4,_]) when Arg2 >= 0, Arg2 =< 255, Arg4 >= 0, Arg4 =< 255 -> 1;
fit_args(l_bs_get_integer_small_imm, [{x,0},Arg1,{f,_},Arg3,{x,_}]) when Arg1 >= 0, Arg1 =< 255, Arg3 >= 0, Arg3 =< 255 -> 0;
fit_args(l_bs_get_integer_small_imm, [{x,_},Arg1,{f,_},Arg3,{x,_}]) when Arg1 >= 0, Arg1 =< 255, Arg3 >= 0, Arg3 =< 255 -> 1;
fit_args(l_bs_get_integer_small_imm, [_,_,{f,_},Arg3,_]) when Arg3 >= 0, Arg3 =< 255 -> 2;
fit_args(l_bs_get_utf16, [{x,0},{f,_},Arg2,{x,_}]) when Arg2 >= 0, Arg2 =< 255 -> 1;
fit_args(l_bs_get_utf16, [{x,_},{f,_},Arg2,{x,_}]) when Arg2 >= 0, Arg2 =< 255 -> 0;
fit_args(l_bs_get_utf16, [_,{f,_},Arg2,_]) when Arg2 >= 0, Arg2 =< 255 -> 2;
fit_args(l_bs_get_utf8, [{x,_},{f,_},{x,_}]) -> 0;
fit_args(l_bs_get_utf8, [_,{f,_},_]) -> 1;
fit_args(l_bs_init, [_,_,Arg2,_]) when Arg2 >= 0, Arg2 =< 255 -> 0;
fit_args(l_bs_init_bits, [_,_,Arg2,_]) when Arg2 >= 0, Arg2 =< 255 -> 0;
fit_args(l_bs_init_bits_fail, [_,{f,_},Arg2,_]) when Arg2 >= 0, Arg2 =< 255 -> 0;
fit_args(l_bs_init_fail, [Arg0,{f,_},Arg2,{x,_}]) when Arg0 >= 0, Arg0 =< 255, Arg2 >= 0, Arg2 =< 255 -> 0;
fit_args(l_bs_init_fail, [_,{f,_},Arg2,_]) when Arg2 >= 0, Arg2 =< 255 -> 1;
fit_args(l_bs_init_heap_bin, [Arg0,Arg1,Arg2,_]) when Arg0 >= 0, Arg0 =< 255, Arg1 >= 0, Arg1 =< 255, Arg2 >= 0, Arg2 =< 255 -> 0;
fit_args(l_bs_init_heap_bin, [_,_,Arg2,_]) when Arg2 >= 0, Arg2 =< 255 -> 1;
fit_args(l_bs_match_string, [{x,1},{f,_},_,{str,_}]) -> 0;
fit_args(l_bs_match_string, [{x,0},{f,_},_,{str,_}]) -> 2;
fit_args(l_bs_match_string, [{x,_},{f,_},Arg2,{str,_}]) when Arg2 >= 0, Arg2 =< 255 -> 3;
fit_args(l_bs_match_string, [_,{f,_},8,{str,_}]) -> 1;
fit_args(l_bs_match_string, [_,{f,_},_,{str,_}]) -> 4;
fit_args(l_bs_private_append, [{f,_},Arg1,_]) when Arg1 >= 0, Arg1 =< 255 -> 0;
fit_args(l_bs_put_string, [1,{str,_}]) -> 0;
fit_args(l_bs_put_string, [4,{str,_}]) -> 1;
fit_args(l_bs_put_string, [_,{str,_}]) -> 2;
fit_args(l_bs_put_utf16, [{f,_},Arg1,_]) when Arg1 >= 0, Arg1 =< 255 -> 0;
fit_args(l_bs_put_utf8, [{f,_},_]) -> 0;
fit_args(l_bs_restore2, [{x,0},0]) -> 1;
fit_args(l_bs_restore2, [{x,0},1]) -> 2;
fit_args(l_bs_restore2, [{x,_},Arg1]) when Arg1 >= 0, Arg1 =< 255 -> 0;
fit_args(l_bs_restore2, [_,_]) -> 3;
fit_args(l_bs_save2, [{x,0},1]) -> 1;
fit_args(l_bs_save2, [{x,_},Arg1]) when Arg1 >= 0, Arg1 =< 255 -> 0;
fit_args(l_bs_save2, [_,_]) -> 2;
fit_args(l_bs_skip_bits2, [{f,_},_,_,Arg3]) when Arg3 >= 0, Arg3 =< 255 -> 0;
fit_args(l_bs_skip_bits_all2, [{f,_},{x,2},8]) -> 0;
fit_args(l_bs_skip_bits_all2, [{f,_},{x,3},8]) -> 1;
fit_args(l_bs_skip_bits_all2, [{f,_},_,Arg2]) when Arg2 >= 0, Arg2 =< 255 -> 2;
fit_args(l_bs_skip_bits_imm2, [{f,_},{x,_},Arg2]) when Arg2 >= 0, Arg2 =< 255 -> 0;
fit_args(l_bs_skip_bits_imm2, [{f,_},_,_]) -> 1;
fit_args(l_bs_start_match2, [{x,0},{f,_},1,0,{x,1}]) -> 0;
fit_args(l_bs_start_match2, [{x,0},{f,_},Arg2,Arg3,{x,0}]) when Arg2 >= 0, Arg2 =< 255, Arg3 >= 0, Arg3 =< 255 -> 2;
fit_args(l_bs_start_match2, [_,{f,_},Arg2,Arg3,{x,0}]) when Arg2 >= 0, Arg2 =< 255, Arg3 >= 0, Arg3 =< 255 -> 3;
fit_args(l_bs_start_match2, [_,{f,_},Arg2,Arg3,{x,_}]) when Arg2 >= 0, Arg2 =< 255, Arg3 >= 0, Arg3 =< 255 -> 1;
fit_args(l_bs_start_match2, [_,{f,_},Arg2,_,_]) when Arg2 >= 0, Arg2 =< 255 -> 4;
fit_args(l_bs_test_tail_imm2, [{f,_},_,_]) -> 0;
fit_args(l_bs_test_unit, [{f,_},_,Arg2]) when Arg2 >= 0, Arg2 =< 255 -> 0;
fit_args(l_bs_test_unit_8, [{f,_},{x,0}]) -> 0;
fit_args(l_bs_test_unit_8, [{f,_},{x,3}]) -> 1;
fit_args(l_bs_test_unit_8, [{f,_},{x,1}]) -> 2;
fit_args(l_bs_test_unit_8, [{f,_},_]) -> 3;
fit_args(l_bs_test_zero_tail2, [{f,_},{x,1}]) -> 0;
fit_args(l_bs_test_zero_tail2, [{f,_},{x,2}]) -> 1;
fit_args(l_bs_test_zero_tail2, [{f,_},{x,0}]) -> 2;
fit_args(l_bs_test_zero_tail2, [{f,_},{x,3}]) -> 3;
fit_args(l_bs_test_zero_tail2, [{f,_},{x,4}]) -> 4;
fit_args(l_bs_test_zero_tail2, [{f,_},_]) -> 5;
fit_args(l_bs_utf16_size, [_,_]) -> 0;
fit_args(l_bs_utf8_size, [_,_]) -> 0;
fit_args(l_bs_validate_unicode, [{f,_},_]) -> 0;
fit_args(l_bs_validate_unicode_retract, [{f,_}]) -> 0;
fit_args(l_bsl, [{f,_},Arg1,{x,0}]) when Arg1 >= 0, Arg1 =< 255 -> 0;
fit_args(l_bsl, [{f,_},Arg1,{x,_}]) when Arg1 >= 0, Arg1 =< 255 -> 1;
fit_args(l_bsl, [{f,_},Arg1,_]) when Arg1 >= 0, Arg1 =< 255 -> 2;
fit_args(l_bsr, [{f,_},Arg1,{x,_}]) when Arg1 >= 0, Arg1 =< 255 -> 0;
fit_args(l_bsr, [{f,_},Arg1,_]) when Arg1 >= 0, Arg1 =< 255 -> 1;
fit_args(l_bxor, [{f,_},Arg1,_]) when Arg1 >= 0, Arg1 =< 255 -> 0;
fit_args(l_call, [{f,_}]) -> 0;
fit_args(l_call_ext, [{e,{lists,reverse,1}}]) -> 0;
fit_args(l_call_ext, [{e,{asn1ct_gen,emit,1}}]) -> 1;
fit_args(l_call_ext, [{e,{file,close,1}}]) -> 2;
fit_args(l_call_ext, [{e,{lists,foreach,2}}]) -> 3;
fit_args(l_call_ext, [{e,{lists,foldl,3}}]) -> 4;
fit_args(l_call_ext, [{e,{lists,sort,1}}]) -> 5;
fit_args(l_call_ext, [{e,{file,open,2}}]) -> 6;
fit_args(l_call_ext, [{e,{lists,map,2}}]) -> 7;
fit_args(l_call_ext, [{e,{filename,join,2}}]) -> 8;
fit_args(l_call_ext, [{e,{lists,flatten,1}}]) -> 9;
fit_args(l_call_ext, [{e,{ordsets,union,2}}]) -> 10;
fit_args(l_call_ext, [{e,{lists,concat,1}}]) -> 11;
fit_args(l_call_ext, [{e,{file,delete,1}}]) -> 13;
fit_args(l_call_ext, [{e,{test_server,timetrap,1}}]) -> 12;
fit_args(l_call_ext, [{e,{test_server,timetrap_cancel,1}}]) -> 14;
fit_args(l_call_ext, [{e,{dict,find,2}}]) -> 16;
fit_args(l_call_ext, [{e,{mnesia_lib,set,2}}]) -> 15;
fit_args(l_call_ext, [{e,{lists,mapfoldl,3}}]) -> 17;
fit_args(l_call_ext, [{e,{dict,new,0}}]) -> 18;
fit_args(l_call_ext, [{e,{test_server,lookup_config,2}}]) -> 19;
fit_args(l_call_ext, [{e,{erl_syntax,type,1}}]) -> 20;
fit_args(l_call_ext, [{e,{erlang,binary_to_term,1}}]) -> 21;
fit_args(l_call_ext, [{e,{dict,store,3}}]) -> 22;
fit_args(l_call_ext, [{e,{prettypr,floating,1}}]) -> 23;
fit_args(l_call_ext, [{e,{proplists,get_value,2}}]) -> 24;
fit_args(l_call_ext, [{e,{erlang,list_to_integer,1}}]) -> 25;
fit_args(l_call_ext, [{e,{filename,join,1}}]) -> 26;
fit_args(l_call_ext, [{e,{lists,usort,1}}]) -> 27;
fit_args(l_call_ext, [{e,{proplists,get_value,3}}]) -> 28;
fit_args(l_call_ext, [{e,{sofs,to_external,1}}]) -> 29;
fit_args(l_call_ext, [{e,{lists,filter,2}}]) -> 30;
fit_args(l_call_ext, [{e,{ordsets,from_list,1}}]) -> 32;
fit_args(l_call_ext, [{e,{string,tokens,2}}]) -> 31;
fit_args(l_call_ext, [{e,{asn1_db,dbget,2}}]) -> 34;
fit_args(l_call_ext, [{e,{prettypr,beside,2}}]) -> 33;
fit_args(l_call_ext, [{e,{lists,append,1}}]) -> 35;
fit_args(l_call_ext, [{e,{erlang,term_to_binary,1}}]) -> 36;
fit_args(l_call_ext, [{e,{lists,last,1}}]) -> 38;
fit_args(l_call_ext, [{e,{erlang,put,2}}]) -> 37;
fit_args(l_call_ext, [{e,{lists,delete,2}}]) -> 39;
fit_args(l_call_ext, [{e,{lists,keydelete,3}}]) -> 40;
fit_args(l_call_ext, [{e,{unicode,characters_to_binary,1}}]) -> 41;
fit_args(l_call_ext, [{e,{erlang,max,2}}]) -> 42;
fit_args(l_call_ext, [{e,{file,read,2}}]) -> 43;
fit_args(l_call_ext, [{e,{file,write,2}}]) -> 47;
fit_args(l_call_ext, [{e,{ordsets,subtract,2}}]) -> 46;
fit_args(l_call_ext, [{e,{gb_trees,lookup,2}}]) -> 45;
fit_args(l_call_ext, [{e,{lists,duplicate,2}}]) -> 44;
fit_args(l_call_ext, [{e,{filename,basename,1}}]) -> 48;
fit_args(l_call_ext, [{e,{file,read_file,1}}]) -> 50;
fit_args(l_call_ext, [{e,{gb_trees,empty,0}}]) -> 49;
fit_args(l_call_ext, [{e,{file,read_file_info,1}}]) -> 51;
fit_args(l_call_ext, [{e,{io,format,3}}]) -> 52;
fit_args(l_call_ext, [{e,{filename,dirname,1}}]) -> 53;
fit_args(l_call_ext, [{e,{file,position,2}}]) -> 56;
fit_args(l_call_ext, [{e,{os,type,0}}]) -> 55;
fit_args(l_call_ext, [{e,{cerl,get_ann,1}}]) -> 54;
fit_args(l_call_ext, [{e,{file,make_dir,1}}]) -> 59;
fit_args(l_call_ext, [{e,{erl_syntax,atom,1}}]) -> 58;
fit_args(l_call_ext, [{e,{ssh_channel,cache_lookup,2}}]) -> 57;
fit_args(l_call_ext, [{e,{orddict,find,2}}]) -> 60;
fit_args(l_call_ext, [{e,{asn1ct_gen,mk_var,1}}]) -> 63;
fit_args(l_call_ext, [{e,{sofs,family_union,2}}]) -> 62;
fit_args(l_call_ext, [{e,{mnesia_lib,exists,1}}]) -> 61;
fit_args(l_call_ext, [{e,{file,rename,2}}]) -> 67;
fit_args(l_call_ext, [{e,{gb_trees,get,2}}]) -> 66;
fit_args(l_call_ext, [{e,{asn1ct_gen,get_inner,1}}]) -> 65;
fit_args(l_call_ext, [{e,{file,get_cwd,0}}]) -> 64;
fit_args(l_call_ext, [{e,{lists,dropwhile,2}}]) -> 69;
fit_args(l_call_ext, [{e,{lists,split,2}}]) -> 68;
fit_args(l_call_ext, [{e,{mnesia_lib,cs_to_storage_type,2}}]) -> 73;
fit_args(l_call_ext, [{e,{lists,splitwith,2}}]) -> 72;
fit_args(l_call_ext, [{e,{test_server,fail,1}}]) -> 71;
fit_args(l_call_ext, [{e,{unicode,characters_to_list,1}}]) -> 70;
fit_args(l_call_ext, [{e,{sofs,relation,1}}]) -> 79;
fit_args(l_call_ext, [{e,{mnesia_monitor,use_dir,0}}]) -> 78;
fit_args(l_call_ext, [{e,{sets,is_element,2}}]) -> 77;
fit_args(l_call_ext, [{e,{lists,sublist,3}}]) -> 76;
fit_args(l_call_ext, [{e,{gb_trees,insert,3}}]) -> 75;
fit_args(l_call_ext, [{e,{random,uniform,1}}]) -> 74;
fit_args(l_call_ext, [{e,{mnesia_schema,list2cs,1}}]) -> 84;
fit_args(l_call_ext, [{e,{gb_trees,from_orddict,1}}]) -> 83;
fit_args(l_call_ext, [{e,{gb_trees,to_list,1}}]) -> 82;
fit_args(l_call_ext, [{e,{gb_sets,empty,0}}]) -> 81;
fit_args(l_call_ext, [{e,{dict,fetch,2}}]) -> 80;
fit_args(l_call_ext, [{e,_}]) -> 85;
fit_args(l_call_ext_last, [{e,_},1]) -> 0;
fit_args(l_call_ext_last, [{e,_},0]) -> 1;
fit_args(l_call_ext_last, [{e,_},2]) -> 2;
fit_args(l_call_ext_last, [{e,_},3]) -> 3;
fit_args(l_call_ext_last, [{e,_},4]) -> 4;
fit_args(l_call_ext_last, [{e,_},5]) -> 5;
fit_args(l_call_ext_last, [{e,_},_]) -> 6;
fit_args(l_call_ext_only, [{e,{gen_server,call,3}}]) -> 0;
fit_args(l_call_ext_only, [{e,{ssh_bits,encode,2}}]) -> 1;
fit_args(l_call_ext_only, [{e,{io,format,3}}]) -> 2;
fit_args(l_call_ext_only, [{e,{asn1ct_gen,emit,1}}]) -> 3;
fit_args(l_call_ext_only, [{e,_}]) -> 4;
fit_args(l_call_fun, [1]) -> 0;
fit_args(l_call_fun, [2]) -> 1;
fit_args(l_call_fun, [3]) -> 2;
fit_args(l_call_fun, [0]) -> 3;
fit_args(l_call_fun, [Arg0]) when Arg0 >= 0, Arg0 =< 255 -> 4;
fit_args(l_call_fun_last, [Arg0,Arg1]) when Arg0 >= 0, Arg0 =< 255, Arg1 >= 0, Arg1 =< 255 -> 0;
fit_args(l_call_fun_last, [Arg0,_]) when Arg0 >= 0, Arg0 =< 255 -> 1;
fit_args(l_call_last, [{f,_},2]) -> 0;
fit_args(l_call_last, [{f,_},0]) -> 1;
fit_args(l_call_last, [{f,_},3]) -> 2;
fit_args(l_call_last, [{f,_},1]) -> 3;
fit_args(l_call_last, [{f,_},4]) -> 4;
fit_args(l_call_last, [{f,_},6]) -> 6;
fit_args(l_call_last, [{f,_},5]) -> 5;
fit_args(l_call_last, [{f,_},7]) -> 7;
fit_args(l_call_last, [{f,_},8]) -> 8;
fit_args(l_call_last, [{f,_},9]) -> 9;
fit_args(l_call_last, [{f,_},10]) -> 10;
fit_args(l_call_last, [{f,_},_]) -> 11;
fit_args(l_call_only, [{f,_}]) -> 0;
fit_args(l_catch, [{y,0},_]) -> 0;
fit_args(l_catch, [{y,1},_]) -> 1;
fit_args(l_catch, [{y,2},_]) -> 2;
fit_args(l_catch, [{y,3},_]) -> 3;
fit_args(l_catch, [{y,4},_]) -> 4;
fit_args(l_catch, [{y,5},_]) -> 5;
fit_args(l_catch, [{y,6},_]) -> 6;
fit_args(l_catch, [_,_]) -> 7;
fit_args(l_element, [{x,0},{x,_},{x,_}]) -> 1;
fit_args(l_element, [{x,_},{x,0},{x,_}]) -> 0;
fit_args(l_element, [{x,_},{x,_},{x,_}]) -> 3;
fit_args(l_element, [_,_,{x,0}]) -> 2;
fit_args(l_element, [_,_,_]) -> 4;
fit_args(l_fadd, [{fr,_},{fr,_},{fr,_}]) -> 0;
fit_args(l_fast_element, [{x,0},2,{x,0}]) -> 0;
fit_args(l_fast_element, [{x,_},Arg1,{y,Arg2}]) when Arg1 >= 0, Arg1 =< 255, Arg2 >= 0, Arg2 =< 255 -> 3;
fit_args(l_fast_element, [_,Arg1,{x,0}]) when Arg1 >= 0, Arg1 =< 255 -> 2;
fit_args(l_fast_element, [_,Arg1,{x,_}]) when Arg1 >= 0, Arg1 =< 255 -> 1;
fit_args(l_fast_element, [_,_,_]) -> 4;
fit_args(l_fcheckerror, []) -> 0;
fit_args(l_fdiv, [{fr,_},{fr,_},{fr,_}]) -> 0;
fit_args(l_fetch, [{i,Arg0},{x,_}]) when Arg0 >= -128, Arg0 =< 127 -> 5;
fit_args(l_fetch, [{i,Arg0},{y,Arg1}]) when Arg0 >= -128, Arg0 =< 127, Arg1 >= 0, Arg1 =< 255 -> 10;
fit_args(l_fetch, [{x,0},_]) -> 0;
fit_args(l_fetch, [{x,1},_]) -> 9;
fit_args(l_fetch, [{x,2},_]) -> 12;
fit_args(l_fetch, [{x,4},_]) -> 13;
fit_args(l_fetch, [{x,3},_]) -> 14;
fit_args(l_fetch, [{x,5},_]) -> 15;
fit_args(l_fetch, [{y,0},_]) -> 18;
fit_args(l_fetch, [{x,_},{i,Arg1}]) when Arg1 >= -128, Arg1 =< 127 -> 3;
fit_args(l_fetch, [{y,Arg0},{i,Arg1}]) when Arg0 >= 0, Arg0 =< 255, Arg1 >= -128, Arg1 =< 127 -> 8;
fit_args(l_fetch, [{x,_},{x,_}]) -> 2;
fit_args(l_fetch, [{x,_},{y,Arg1}]) when Arg1 >= 0, Arg1 =< 255 -> 4;
fit_args(l_fetch, [{y,Arg0},{y,Arg1}]) when Arg0 >= 0, Arg0 =< 255, Arg1 >= 0, Arg1 =< 255 -> 6;
fit_args(l_fetch, [{y,Arg0},{x,_}]) when Arg0 >= 0, Arg0 =< 255 -> 7;
fit_args(l_fetch, [_,{x,0}]) -> 1;
fit_args(l_fetch, [_,{x,1}]) -> 11;
fit_args(l_fetch, [_,{x,4}]) -> 16;
fit_args(l_fetch, [_,{x,2}]) -> 17;
fit_args(l_fetch, [_,{x,3}]) -> 19;
fit_args(l_fetch, [_,{x,5}]) -> 20;
fit_args(l_fetch, [_,{y,0}]) -> 21;
fit_args(l_fetch, [_,_]) -> 22;
fit_args(l_fmul, [{fr,_},{fr,_},{fr,_}]) -> 0;
fit_args(l_fnegate, [{fr,_},{fr,_}]) -> 0;
fit_args(l_fsub, [{fr,_},{fr,_},{fr,_}]) -> 0;
fit_args(l_gc_bif1, [{f,_},{b,{erlang,byte_size,1}},{x,_},Arg3,{x,0}]) when Arg3 >= 0, Arg3 =< 255 -> 2;
fit_args(l_gc_bif1, [{f,_},{b,{erlang,length,1}},_,Arg3,{x,0}]) when Arg3 >= 0, Arg3 =< 255 -> 1;
fit_args(l_gc_bif1, [{f,_},{b,{erlang,length,1}},_,Arg3,{y,Arg4}]) when Arg3 >= 0, Arg3 =< 255, Arg4 >= 0, Arg4 =< 255 -> 4;
fit_args(l_gc_bif1, [{f,_},{b,_},{x,0},1,{x,0}]) -> 3;
fit_args(l_gc_bif1, [{f,_},{b,_},_,Arg3,{x,0}]) when Arg3 >= 0, Arg3 =< 255 -> 5;
fit_args(l_gc_bif1, [{f,_},{b,_},_,Arg3,{x,_}]) when Arg3 >= 0, Arg3 =< 255 -> 0;
fit_args(l_gc_bif1, [{f,_},{b,_},_,Arg3,_]) when Arg3 >= 0, Arg3 =< 255 -> 6;
fit_args(l_gc_bif2, [{f,_},{b,_},Arg2,_]) when Arg2 >= 0, Arg2 =< 255 -> 0;
fit_args(l_gc_bif3, [{f,_},{b,_},_,Arg3,_]) when Arg3 >= 0, Arg3 =< 255 -> 0;
fit_args(l_get, [{a,asn1_module},{y,0}]) -> 0;
fit_args(l_get, [_,{x,0}]) -> 1;
fit_args(l_get, [_,{x,1}]) -> 2;
fit_args(l_get, [_,{x,2}]) -> 3;
fit_args(l_get, [_,_]) -> 4;
fit_args(l_hibernate, []) -> 0;
fit_args(l_increment, [{x,0},Arg1,Arg2,{x,_}]) when Arg1 >= 0, Arg1 =< 255, Arg2 >= 0, Arg2 =< 255 -> 5;
fit_args(l_increment, [{x,0},_,Arg2,{x,0}]) when Arg2 >= 0, Arg2 =< 255 -> 3;
fit_args(l_increment, [{x,0},_,Arg2,{y,Arg3}]) when Arg2 >= 0, Arg2 =< 255, Arg3 >= 0, Arg3 =< 255 -> 7;
fit_args(l_increment, [{x,_},Arg1,Arg2,_]) when Arg1 >= 0, Arg1 =< 255, Arg2 >= 0, Arg2 =< 255 -> 0;
fit_args(l_increment, [{y,Arg0},Arg1,Arg2,_]) when Arg0 >= 0, Arg0 =< 255, Arg1 >= 0, Arg1 =< 255, Arg2 >= 0, Arg2 =< 255 -> 1;
fit_args(l_increment, [{x,_},_,Arg2,{x,_}]) when Arg2 >= 0, Arg2 =< 255 -> 6;
fit_args(l_increment, [_,4294967295,Arg2,{x,0}]) when Arg2 >= 0, Arg2 =< 255 -> 4;
fit_args(l_increment, [_,4294967295,Arg2,{x,_}]) when Arg2 >= 0, Arg2 =< 255 -> 2;
fit_args(l_increment, [_,_,Arg2,_]) when Arg2 >= 0, Arg2 =< 255 -> 8;
fit_args(l_int_bnot, [{f,_},_,Arg2,_]) when Arg2 >= 0, Arg2 =< 255 -> 0;
fit_args(l_int_div, [{f,_},Arg1,{x,0}]) when Arg1 >= 0, Arg1 =< 255 -> 1;
fit_args(l_int_div, [{f,_},Arg1,{x,_}]) when Arg1 >= 0, Arg1 =< 255 -> 0;
fit_args(l_int_div, [{f,_},Arg1,_]) when Arg1 >= 0, Arg1 =< 255 -> 2;
fit_args(l_is_eq, [{f,_}]) -> 0;
fit_args(l_is_eq_exact, [{f,_}]) -> 0;
fit_args(l_is_eq_exact_immed, [{f,_},{y,10},{a,ber}]) -> 23;
fit_args(l_is_eq_exact_immed, [{f,_},{x,1},_]) -> 0;
fit_args(l_is_eq_exact_immed, [{f,_},{x,0},_]) -> 1;
fit_args(l_is_eq_exact_immed, [{f,_},{x,3},_]) -> 2;
fit_args(l_is_eq_exact_immed, [{f,_},{x,2},_]) -> 3;
fit_args(l_is_eq_exact_immed, [{f,_},{x,4},_]) -> 5;
fit_args(l_is_eq_exact_immed, [{f,_},{x,5},_]) -> 6;
fit_args(l_is_eq_exact_immed, [{f,_},{x,6},_]) -> 7;
fit_args(l_is_eq_exact_immed, [{f,_},{x,7},_]) -> 8;
fit_args(l_is_eq_exact_immed, [{f,_},{x,8},_]) -> 9;
fit_args(l_is_eq_exact_immed, [{f,_},{x,9},_]) -> 10;
fit_args(l_is_eq_exact_immed, [{f,_},{x,255},_]) -> 11;
fit_args(l_is_eq_exact_immed, [{f,_},{x,10},_]) -> 12;
fit_args(l_is_eq_exact_immed, [{f,_},{x,11},_]) -> 13;
fit_args(l_is_eq_exact_immed, [{f,_},{y,1},_]) -> 14;
fit_args(l_is_eq_exact_immed, [{f,_},{x,12},_]) -> 15;
fit_args(l_is_eq_exact_immed, [{f,_},{y,0},_]) -> 16;
fit_args(l_is_eq_exact_immed, [{f,_},{x,13},_]) -> 17;
fit_args(l_is_eq_exact_immed, [{f,_},{y,3},_]) -> 18;
fit_args(l_is_eq_exact_immed, [{f,_},{y,2},_]) -> 19;
fit_args(l_is_eq_exact_immed, [{f,_},{y,4},_]) -> 20;
fit_args(l_is_eq_exact_immed, [{f,_},{x,14},_]) -> 21;
fit_args(l_is_eq_exact_immed, [{f,_},{y,5},_]) -> 22;
fit_args(l_is_eq_exact_immed, [{f,_},{x,16},_]) -> 24;
fit_args(l_is_eq_exact_immed, [{f,_},{x,15},_]) -> 25;
fit_args(l_is_eq_exact_immed, [{f,_},{x,17},_]) -> 26;
fit_args(l_is_eq_exact_immed, [{f,_},{x,18},_]) -> 28;
fit_args(l_is_eq_exact_immed, [{f,_},{x,19},_]) -> 29;
fit_args(l_is_eq_exact_immed, [{f,_},{y,6},_]) -> 30;
fit_args(l_is_eq_exact_immed, [{f,_},{x,22},_]) -> 31;
fit_args(l_is_eq_exact_immed, [{f,_},{y,7},_]) -> 32;
fit_args(l_is_eq_exact_immed, [{f,_},{x,20},_]) -> 33;
fit_args(l_is_eq_exact_immed, [{f,_},{y,8},_]) -> 34;
fit_args(l_is_eq_exact_immed, [{f,_},{x,23},_]) -> 35;
fit_args(l_is_eq_exact_immed, [{f,_},{x,_},{i,Arg2}]) when Arg2 >= -128, Arg2 =< 127 -> 4;
fit_args(l_is_eq_exact_immed, [{f,_},_,{a,asn1_NOVALUE}]) -> 27;
fit_args(l_is_eq_exact_immed, [{f,_},_,_]) -> 36;
fit_args(l_is_eq_exact_literal, [{f,_},{x,0},_]) -> 0;
fit_args(l_is_eq_exact_literal, [{f,_},{x,1},_]) -> 1;
fit_args(l_is_eq_exact_literal, [{f,_},{x,4},_]) -> 2;
fit_args(l_is_eq_exact_literal, [{f,_},{x,2},_]) -> 3;
fit_args(l_is_eq_exact_literal, [{f,_},{x,3},_]) -> 4;
fit_args(l_is_eq_exact_literal, [{f,_},{x,5},_]) -> 5;
fit_args(l_is_eq_exact_literal, [{f,_},{x,6},_]) -> 6;
fit_args(l_is_eq_exact_literal, [{f,_},_,_]) -> 7;
fit_args(l_is_function2, [{f,_},{x,0},Arg2]) when Arg2 >= 0, Arg2 =< 255 -> 0;
fit_args(l_is_function2, [{f,_},{x,_},Arg2]) when Arg2 >= 0, Arg2 =< 255 -> 1;
fit_args(l_is_function2, [{f,_},_,Arg2]) when Arg2 >= 0, Arg2 =< 255 -> 2;
fit_args(l_is_ge, [{f,_}]) -> 0;
fit_args(l_is_lt, [{f,_}]) -> 0;
fit_args(l_is_ne, [{f,_}]) -> 0;
fit_args(l_is_ne_exact, [{f,_}]) -> 0;
fit_args(l_is_ne_exact_immed, [{f,_},{x,0},_]) -> 0;
fit_args(l_is_ne_exact_immed, [{f,_},{x,1},_]) -> 1;
fit_args(l_is_ne_exact_immed, [{f,_},{x,2},_]) -> 2;
fit_args(l_is_ne_exact_immed, [{f,_},{x,3},_]) -> 3;
fit_args(l_is_ne_exact_immed, [{f,_},{x,4},_]) -> 5;
fit_args(l_is_ne_exact_immed, [{f,_},{y,0},_]) -> 6;
fit_args(l_is_ne_exact_immed, [{f,_},{y,2},_]) -> 8;
fit_args(l_is_ne_exact_immed, [{f,_},{y,1},_]) -> 9;
fit_args(l_is_ne_exact_immed, [{f,_},{x,5},_]) -> 10;
fit_args(l_is_ne_exact_immed, [{f,_},{x,_},{i,Arg2}]) when Arg2 >= -128, Arg2 =< 127 -> 7;
fit_args(l_is_ne_exact_immed, [{f,_},_,{a,true}]) -> 4;
fit_args(l_is_ne_exact_immed, [{f,_},_,_]) -> 11;
fit_args(l_is_ne_exact_literal, [{f,_},_,_]) -> 0;
fit_args(l_jump_on_val, [{x,0},{f,_},Arg2,Arg3]) when Arg2 >= 0, Arg2 =< 255, Arg3 >= 0, Arg3 =< 255 -> 1;
fit_args(l_jump_on_val, [{x,_},{f,_},Arg2,Arg3]) when Arg2 >= 0, Arg2 =< 255, Arg3 >= 0, Arg3 =< 255 -> 0;
fit_args(l_jump_on_val, [_,{f,_},_,_]) -> 2;
fit_args(l_loop_rec, [{f,_}]) -> 0;
fit_args(l_m_div, [{f,_},Arg1,_]) when Arg1 >= 0, Arg1 =< 255 -> 0;
fit_args(l_make_export, [{e,_}]) -> 0;
fit_args(l_make_fun, [{fu,_}]) -> 0;
fit_args(l_minus, [{f,_},Arg1,{x,0}]) when Arg1 >= 0, Arg1 =< 255 -> 1;
fit_args(l_minus, [{f,_},Arg1,{x,_}]) when Arg1 >= 0, Arg1 =< 255 -> 0;
fit_args(l_minus, [{f,_},Arg1,_]) when Arg1 >= 0, Arg1 =< 255 -> 2;
fit_args(l_move_call, [{x,2},{f,_}]) -> 0;
fit_args(l_move_call, [{x,1},{f,_}]) -> 1;
fit_args(l_move_call, [{y,2},{f,_}]) -> 2;
fit_args(l_move_call, [{y,0},{f,_}]) -> 3;
fit_args(l_move_call, [{y,1},{f,_}]) -> 4;
fit_args(l_move_call, [{y,3},{f,_}]) -> 5;
fit_args(l_move_call, [{x,3},{f,_}]) -> 6;
fit_args(l_move_call, [{y,5},{f,_}]) -> 7;
fit_args(l_move_call, [{y,4},{f,_}]) -> 8;
fit_args(l_move_call, [{y,6},{f,_}]) -> 10;
fit_args(l_move_call, [{x,4},{f,_}]) -> 11;
fit_args(l_move_call, [{x,5},{f,_}]) -> 12;
fit_args(l_move_call, [nil,{f,_}]) -> 13;
fit_args(l_move_call, [{y,7},{f,_}]) -> 14;
fit_args(l_move_call, [{a,foo},{f,_}]) -> 17;
fit_args(l_move_call, [{x,6},{f,_}]) -> 18;
fit_args(l_move_call, [{y,12},{f,_}]) -> 19;
fit_args(l_move_call, [{a,endDocument},{f,_}]) -> 20;
fit_args(l_move_call, [{a,ets},{f,_}]) -> 23;
fit_args(l_move_call, [{a,schema},{f,_}]) -> 22;
fit_args(l_move_call, [{y,8},{f,_}]) -> 24;
fit_args(l_move_call, [{a,false},{f,_}]) -> 25;
fit_args(l_move_call, [{smallint,1},{f,_}]) -> 9;
fit_args(l_move_call, [{smallint,0},{f,_}]) -> 15;
fit_args(l_move_call, [{smallint,2},{f,_}]) -> 16;
fit_args(l_move_call, [{smallint,3},{f,_}]) -> 21;
fit_args(l_move_call, [_,{f,_}]) -> 26;
fit_args(l_move_call_ext, [{a,funky},{e,{estone_SUITE,req,2}}]) -> 32;
fit_args(l_move_call_ext, [{a,auto_repair},{e,{mnesia_monitor,get_env,1}}]) -> 36;
fit_args(l_move_call_ext, [{y,0},{e,_}]) -> 3;
fit_args(l_move_call_ext, [{y,1},{e,_}]) -> 4;
fit_args(l_move_call_ext, [{y,2},{e,_}]) -> 5;
fit_args(l_move_call_ext, [{y,3},{e,_}]) -> 6;
fit_args(l_move_call_ext, [{y,4},{e,_}]) -> 7;
fit_args(l_move_call_ext, [{x,2},{e,_}]) -> 9;
fit_args(l_move_call_ext, [{x,1},{e,_}]) -> 10;
fit_args(l_move_call_ext, [{y,6},{e,_}]) -> 13;
fit_args(l_move_call_ext, [{x,3},{e,_}]) -> 16;
fit_args(l_move_call_ext, [{y,5},{e,_}]) -> 17;
fit_args(l_move_call_ext, [nil,{e,_}]) -> 20;
fit_args(l_move_call_ext, [{y,7},{e,_}]) -> 24;
fit_args(l_move_call_ext, [{x,4},{e,_}]) -> 26;
fit_args(l_move_call_ext, [{smallint,0},{e,{lists,seq,2}}]) -> 15;
fit_args(l_move_call_ext, [{smallint,1},{e,_}]) -> 8;
fit_args(l_move_call_ext, [_,{e,{re,split,3}}]) -> 0;
fit_args(l_move_call_ext, [_,{e,{re,replace,4}}]) -> 1;
fit_args(l_move_call_ext, [_,{e,{io,format,2}}]) -> 2;
fit_args(l_move_call_ext, [_,{e,{io_lib,format,2}}]) -> 11;
fit_args(l_move_call_ext, [_,{e,{asn1ct_gen,emit,1}}]) -> 12;
fit_args(l_move_call_ext, [_,{e,{erlang,put,2}}]) -> 14;
fit_args(l_move_call_ext, [_,{e,{prettypr,text,1}}]) -> 18;
fit_args(l_move_call_ext, [_,{e,{proplists,get_value,3}}]) -> 19;
fit_args(l_move_call_ext, [_,{e,{test_server,seconds,1}}]) -> 21;
fit_args(l_move_call_ext, [_,{e,{asn1ct_name,new,1}}]) -> 22;
fit_args(l_move_call_ext, [_,{e,{proplists,get_value,2}}]) -> 23;
fit_args(l_move_call_ext, [_,{e,{mnesia_lib,verbose,2}}]) -> 25;
fit_args(l_move_call_ext, [_,{e,{io,format,1}}]) -> 27;
fit_args(l_move_call_ext, [_,{e,{lists,duplicate,2}}]) -> 28;
fit_args(l_move_call_ext, [_,{e,{erlang,system_info,1}}]) -> 29;
fit_args(l_move_call_ext, [_,{e,{erlang,erase,1}}]) -> 30;
fit_args(l_move_call_ext, [_,{e,{lists,seq,2}}]) -> 31;
fit_args(l_move_call_ext, [_,{e,{mnesia_lib,dbg_out,2}}]) -> 33;
fit_args(l_move_call_ext, [_,{e,{erlang,binary_to_term,1}}]) -> 34;
fit_args(l_move_call_ext, [_,{e,{test_server,lookup_config,2}}]) -> 35;
fit_args(l_move_call_ext, [_,{e,{io,fwrite,2}}]) -> 37;
fit_args(l_move_call_ext, [_,{e,_}]) -> 38;
fit_args(l_move_call_ext_last, [{e,_},0,_]) -> 1;
fit_args(l_move_call_ext_last, [{e,_},1,_]) -> 2;
fit_args(l_move_call_ext_last, [{e,_},2,_]) -> 3;
fit_args(l_move_call_ext_last, [{e,_},Arg1,{y,Arg2}]) when Arg1 >= 0, Arg1 =< 255, Arg2 >= 0, Arg2 =< 255 -> 0;
fit_args(l_move_call_ext_last, [{e,_},_,_]) -> 4;
fit_args(l_move_call_ext_only, [{e,{erlang,nif_error,1}},{a,undef}]) -> 2;
fit_args(l_move_call_ext_only, [{e,{lists,reverse,1}},{x,_}]) -> 3;
fit_args(l_move_call_ext_only, [{e,{erlang,get_module_info,1}},_]) -> 0;
fit_args(l_move_call_ext_only, [{e,{io_lib,format,2}},_]) -> 1;
fit_args(l_move_call_ext_only, [{e,{io,format,2}},_]) -> 5;
fit_args(l_move_call_ext_only, [{e,_},{x,2}]) -> 4;
fit_args(l_move_call_ext_only, [{e,_},{x,1}]) -> 6;
fit_args(l_move_call_ext_only, [{e,_},_]) -> 7;
fit_args(l_move_call_last, [{f,_},1,_]) -> 1;
fit_args(l_move_call_last, [{f,_},2,_]) -> 3;
fit_args(l_move_call_last, [{f,_},0,_]) -> 4;
fit_args(l_move_call_last, [{f,_},3,_]) -> 5;
fit_args(l_move_call_last, [{f,_},5,_]) -> 6;
fit_args(l_move_call_last, [{f,_},4,_]) -> 7;
fit_args(l_move_call_last, [{f,_},Arg1,{y,Arg2}]) when Arg1 >= 0, Arg1 =< 255, Arg2 >= 0, Arg2 =< 255 -> 0;
fit_args(l_move_call_last, [{f,_},Arg1,{x,_}]) when Arg1 >= 0, Arg1 =< 255 -> 2;
fit_args(l_move_call_last, [{f,_},_,_]) -> 8;
fit_args(l_move_call_only, [{f,_},{x,2}]) -> 0;
fit_args(l_move_call_only, [{f,_},{x,1}]) -> 1;
fit_args(l_move_call_only, [{f,_},{x,4}]) -> 2;
fit_args(l_move_call_only, [{f,_},{x,3}]) -> 3;
fit_args(l_move_call_only, [{f,_},{x,5}]) -> 4;
fit_args(l_move_call_only, [{f,_},{x,6}]) -> 5;
fit_args(l_move_call_only, [{f,_},{x,7}]) -> 6;
fit_args(l_move_call_only, [{f,_},nil]) -> 7;
fit_args(l_move_call_only, [{f,_},{x,8}]) -> 8;
fit_args(l_move_call_only, [{f,_},{x,9}]) -> 10;
fit_args(l_move_call_only, [{f,_},{x,10}]) -> 11;
fit_args(l_move_call_only, [{f,_},{smallint,1}]) -> 9;
fit_args(l_move_call_only, [{f,_},_]) -> 12;
fit_args(l_new_bs_put_binary, [{f,_},_,Arg2,Arg3,_]) when Arg2 >= 0, Arg2 =< 255, Arg3 >= 0, Arg3 =< 255 -> 0;
fit_args(l_new_bs_put_binary_all, [{f,_},_,8]) -> 0;
fit_args(l_new_bs_put_binary_all, [{f,_},_,Arg2]) when Arg2 >= 0, Arg2 =< 255 -> 1;
fit_args(l_new_bs_put_binary_imm, [{f,_},_,Arg2,_]) when Arg2 >= 0, Arg2 =< 255 -> 0;
fit_args(l_new_bs_put_float, [{f,_},_,Arg2,Arg3,_]) when Arg2 >= 0, Arg2 =< 255, Arg3 >= 0, Arg3 =< 255 -> 0;
fit_args(l_new_bs_put_float_imm, [{f,_},64,0,{x,0}]) -> 0;
fit_args(l_new_bs_put_float_imm, [{f,_},_,Arg2,_]) when Arg2 >= 0, Arg2 =< 255 -> 1;
fit_args(l_new_bs_put_integer, [{f,_},_,1,0,_]) -> 0;
fit_args(l_new_bs_put_integer, [{f,_},_,Arg2,Arg3,_]) when Arg2 >= 0, Arg2 =< 255, Arg3 >= 0, Arg3 =< 255 -> 1;
fit_args(l_new_bs_put_integer_imm, [{f,_},Arg1,Arg2,_]) when Arg1 >= 0, Arg1 =< 255, Arg2 >= 0, Arg2 =< 255 -> 0;
fit_args(l_new_bs_put_integer_imm, [{f,_},_,0,{smallint,0}]) -> 1;
fit_args(l_new_bs_put_integer_imm, [{f,_},_,Arg2,_]) when Arg2 >= 0, Arg2 =< 255 -> 2;
fit_args(l_plus, [{f,_},Arg1,{x,0}]) when Arg1 >= 0, Arg1 =< 255 -> 1;
fit_args(l_plus, [{f,_},Arg1,{x,_}]) when Arg1 >= 0, Arg1 =< 255 -> 0;
fit_args(l_plus, [{f,_},Arg1,{y,Arg2}]) when Arg1 >= 0, Arg1 =< 255, Arg2 >= 0, Arg2 =< 255 -> 2;
fit_args(l_plus, [{f,_},Arg1,_]) when Arg1 >= 0, Arg1 =< 255 -> 3;
fit_args(l_put_tuple, [{x,0},2]) -> 1;
fit_args(l_put_tuple, [{x,0},3]) -> 2;
fit_args(l_put_tuple, [{x,0},4]) -> 3;
fit_args(l_put_tuple, [{x,0},5]) -> 4;
fit_args(l_put_tuple, [{x,0},Arg1]) when Arg1 >= 0, Arg1 =< 255 -> 5;
fit_args(l_put_tuple, [{x,_},Arg1]) when Arg1 >= 0, Arg1 =< 255 -> 0;
fit_args(l_put_tuple, [{y,Arg0},Arg1]) when Arg0 >= 0, Arg0 =< 255, Arg1 >= 0, Arg1 =< 255 -> 6;
fit_args(l_put_tuple, [_,_]) -> 7;
fit_args(l_recv_set, []) -> 0;
fit_args(l_rem, [{f,_},Arg1,{x,0}]) when Arg1 >= 0, Arg1 =< 255 -> 1;
fit_args(l_rem, [{f,_},Arg1,{x,_}]) when Arg1 >= 0, Arg1 =< 255 -> 0;
fit_args(l_rem, [{f,_},Arg1,_]) when Arg1 >= 0, Arg1 =< 255 -> 2;
fit_args(l_select_tuple_arity, [{x,0},{f,_},6]) -> 0;
fit_args(l_select_tuple_arity, [{x,0},{f,_},8]) -> 2;
fit_args(l_select_tuple_arity, [{x,0},{f,_},10]) -> 3;
fit_args(l_select_tuple_arity, [{x,_},{f,_},Arg2]) when Arg2 >= 0, Arg2 =< 255 -> 1;
fit_args(l_select_tuple_arity, [_,{f,_},_]) -> 4;
fit_args(l_select_tuple_arity2, [{x,0},{f,_},Arg2,{f,_},Arg4,{f,_}]) when Arg2 >= 0, Arg2 =< 255, Arg4 >= 0, Arg4 =< 255 -> 0;
fit_args(l_select_tuple_arity2, [{x,_},{f,_},Arg2,{f,_},Arg4,{f,_}]) when Arg2 >= 0, Arg2 =< 255, Arg4 >= 0, Arg4 =< 255 -> 1;
fit_args(l_select_tuple_arity2, [{y,Arg0},{f,_},Arg2,{f,_},Arg4,{f,_}]) when Arg0 >= 0, Arg0 =< 255, Arg2 >= 0, Arg2 =< 255, Arg4 >= 0, Arg4 =< 255 -> 2;
fit_args(l_select_tuple_arity2, [_,{f,_},_,{f,_},_,{f,_}]) -> 3;
fit_args(l_select_val2, [{x,0},{f,_},{a,false},{f,_},{a,true},{f,_}]) -> 0;
fit_args(l_select_val2, [{x,0},{f,_},{a,true},{f,_},{a,false},{f,_}]) -> 1;
fit_args(l_select_val2, [{x,9},{f,_},{a,atom},{f,_},{a,var},{f,_}]) -> 13;
fit_args(l_select_val2, [{x,1},{f,_},_,{f,_},_,{f,_}]) -> 3;
fit_args(l_select_val2, [{x,0},{f,_},_,{f,_},_,{f,_}]) -> 4;
fit_args(l_select_val2, [{x,2},{f,_},_,{f,_},_,{f,_}]) -> 6;
fit_args(l_select_val2, [{x,3},{f,_},_,{f,_},_,{f,_}]) -> 7;
fit_args(l_select_val2, [{x,4},{f,_},_,{f,_},_,{f,_}]) -> 9;
fit_args(l_select_val2, [{x,5},{f,_},_,{f,_},_,{f,_}]) -> 10;
fit_args(l_select_val2, [{x,6},{f,_},_,{f,_},_,{f,_}]) -> 11;
fit_args(l_select_val2, [{x,7},{f,_},_,{f,_},_,{f,_}]) -> 12;
fit_args(l_select_val2, [{x,8},{f,_},_,{f,_},_,{f,_}]) -> 14;
fit_args(l_select_val2, [{y,1},{f,_},_,{f,_},_,{f,_}]) -> 15;
fit_args(l_select_val2, [{x,_},{f,_},{i,Arg2},{f,_},{i,Arg4},{f,_}]) when Arg2 >= -128, Arg2 =< 127, Arg4 >= -128, Arg4 =< 127 -> 2;
fit_args(l_select_val2, [_,{f,_},{a,true},{f,_},{a,false},{f,_}]) -> 5;
fit_args(l_select_val2, [_,{f,_},{a,false},{f,_},{a,true},{f,_}]) -> 8;
fit_args(l_select_val2, [_,{f,_},_,{f,_},_,{f,_}]) -> 16;
fit_args(l_select_val_atoms, [{x,0},{f,_},_]) -> 1;
fit_args(l_select_val_atoms, [{x,_},{f,_},Arg2]) when Arg2 >= 0, Arg2 =< 255 -> 0;
fit_args(l_select_val_atoms, [_,{f,_},_]) -> 2;
fit_args(l_select_val_smallints, [{x,0},{f,_},_]) -> 1;
fit_args(l_select_val_smallints, [{x,_},{f,_},Arg2]) when Arg2 >= 0, Arg2 =< 255 -> 0;
fit_args(l_select_val_smallints, [_,{f,_},_]) -> 2;
fit_args(l_times, [{f,_},Arg1,{x,0}]) when Arg1 >= 0, Arg1 =< 255 -> 1;
fit_args(l_times, [{f,_},Arg1,{x,_}]) when Arg1 >= 0, Arg1 =< 255 -> 0;
fit_args(l_times, [{f,_},Arg1,_]) when Arg1 >= 0, Arg1 =< 255 -> 2;
fit_args(l_trim, [1]) -> 0;
fit_args(l_trim, [2]) -> 1;
fit_args(l_trim, [3]) -> 2;
fit_args(l_trim, [4]) -> 3;
fit_args(l_trim, [5]) -> 4;
fit_args(l_trim, [6]) -> 5;
fit_args(l_trim, [7]) -> 6;
fit_args(l_trim, [8]) -> 7;
fit_args(l_trim, [9]) -> 8;
fit_args(l_trim, [11]) -> 9;
fit_args(l_trim, [10]) -> 10;
fit_args(l_trim, [_]) -> 11;
fit_args(l_wait_timeout, [{f,_},1000]) -> 0;
fit_args(l_wait_timeout, [{f,_},1]) -> 1;
fit_args(l_wait_timeout, [{f,_},_]) -> 2;
fit_args(l_yield, []) -> 0;
fit_args(loop_rec_end, [{f,_}]) -> 0;
fit_args(move, [{x,0},_]) -> 4;
fit_args(move, [{x,_},{y,Arg1}]) when Arg1 >= 0, Arg1 =< 255 -> 3;
fit_args(move, [{y,Arg0},{y,Arg1}]) when Arg0 >= 0, Arg0 =< 255, Arg1 >= 0, Arg1 =< 255 -> 7;
fit_args(move, [_,{x,1}]) -> 0;
fit_args(move, [_,{x,0}]) -> 1;
fit_args(move, [_,{x,2}]) -> 2;
fit_args(move, [_,{x,3}]) -> 5;
fit_args(move, [_,{x,4}]) -> 6;
fit_args(move, [_,{x,5}]) -> 8;
fit_args(move, [_,{x,6}]) -> 9;
fit_args(move, [_,{x,7}]) -> 10;
fit_args(move, [_,{x,8}]) -> 11;
fit_args(move, [_,{x,10}]) -> 12;
fit_args(move, [_,{x,9}]) -> 13;
fit_args(move, [_,_]) -> 14;
fit_args(move2, [{x,0},{x,_},{x,0},{x,_}]) -> 9;
fit_args(move2, [{x,0},{x,_},{x,_},{x,0}]) -> 6;
fit_args(move2, [{x,0},{y,Arg1},{x,_},{y,Arg3}]) when Arg1 >= 0, Arg1 =< 255, Arg3 >= 0, Arg3 =< 255 -> 4;
fit_args(move2, [{x,0},{x,_},{x,_},{x,_}]) -> 8;
fit_args(move2, [{x,_},{x,0},{x,_},{x,_}]) -> 5;
fit_args(move2, [{x,_},{y,Arg1},{x,0},{y,Arg3}]) when Arg1 >= 0, Arg1 =< 255, Arg3 >= 0, Arg3 =< 255 -> 3;
fit_args(move2, [{x,_},{x,_},{x,0},{x,_}]) -> 7;
fit_args(move2, [{x,_},{y,Arg1},{x,_},{y,Arg3}]) when Arg1 >= 0, Arg1 =< 255, Arg3 >= 0, Arg3 =< 255 -> 0;
fit_args(move2, [{y,Arg0},{x,_},{y,Arg2},_]) when Arg0 >= 0, Arg0 =< 255, Arg2 >= 0, Arg2 =< 255 -> 1;
fit_args(move2, [{x,_},{x,_},{x,_},_]) -> 2;
fit_args(move2, [_,_,_,_]) -> 10;
fit_args(move_deallocate_return, [{a,ok},_]) -> 1;
fit_args(move_deallocate_return, [{x,_},Arg1]) when Arg1 >= 0, Arg1 =< 255 -> 0;
fit_args(move_deallocate_return, [{y,Arg0},Arg1]) when Arg0 >= 0, Arg0 =< 255, Arg1 >= 0, Arg1 =< 255 -> 2;
fit_args(move_deallocate_return, [_,0]) -> 3;
fit_args(move_deallocate_return, [_,1]) -> 4;
fit_args(move_deallocate_return, [_,2]) -> 5;
fit_args(move_deallocate_return, [_,3]) -> 6;
fit_args(move_deallocate_return, [_,4]) -> 7;
fit_args(move_deallocate_return, [_,5]) -> 8;
fit_args(move_deallocate_return, [_,_]) -> 9;
fit_args(move_jump, [{f,_},{x,1}]) -> 0;
fit_args(move_jump, [{f,_},{x,2}]) -> 1;
fit_args(move_jump, [{f,_},nil]) -> 2;
fit_args(move_jump, [{f,_},{x,4}]) -> 3;
fit_args(move_jump, [{f,_},{y,2}]) -> 4;
fit_args(move_jump, [{f,_},{y,1}]) -> 5;
fit_args(move_jump, [{f,_},{x,3}]) -> 6;
fit_args(move_jump, [{f,_},{y,0}]) -> 7;
fit_args(move_jump, [{f,_},{y,3}]) -> 8;
fit_args(move_jump, [{f,_},{a,true}]) -> 9;
fit_args(move_jump, [{f,_},{a,false}]) -> 10;
fit_args(move_jump, [{f,_},{a,asn1_NOVALUE}]) -> 11;
fit_args(move_jump, [{f,_},{y,4}]) -> 12;
fit_args(move_jump, [{f,_},{smallint,0}]) -> 13;
fit_args(move_jump, [{f,_},_]) -> 14;
fit_args(move_return, [{a,true}]) -> 0;
fit_args(move_return, [{x,1}]) -> 1;
fit_args(move_return, [{x,2}]) -> 2;
fit_args(move_return, [nil]) -> 3;
fit_args(move_return, [{a,false}]) -> 4;
fit_args(move_return, [{a,ok}]) -> 5;
fit_args(move_return, [{x,3}]) -> 6;
fit_args(move_return, [{x,4}]) -> 7;
fit_args(move_return, [{a,undefined}]) -> 11;
fit_args(move_return, [{x,5}]) -> 12;
fit_args(move_return, [{a,error}]) -> 13;
fit_args(move_return, [{a,none}]) -> 16;
fit_args(move_return, [{a,no}]) -> 15;
fit_args(move_return, [{a,nomatch}]) -> 19;
fit_args(move_return, [{a,ignore}]) -> 20;
fit_args(move_return, [{x,6}]) -> 22;
fit_args(move_return, [{smallint,1}]) -> 8;
fit_args(move_return, [{smallint,0}]) -> 9;
fit_args(move_return, [{smallint,2}]) -> 10;
fit_args(move_return, [{smallint,3}]) -> 14;
fit_args(move_return, [{smallint,4}]) -> 17;
fit_args(move_return, [{smallint,8}]) -> 18;
fit_args(move_return, [{smallint,16}]) -> 21;
fit_args(move_return, [{smallint,5}]) -> 24;
fit_args(move_return, [{smallint,64}]) -> 23;
fit_args(move_return, [_]) -> 25;
fit_args(node, [{x,0}]) -> 0;
fit_args(node, [{x,1}]) -> 1;
fit_args(node, [{x,2}]) -> 2;
fit_args(node, [{x,3}]) -> 3;
fit_args(node, [_]) -> 4;
fit_args(on_load, []) -> 0;
fit_args(put_list, [{x,0},{x,3},{x,8}]) -> 12;
fit_args(put_list, [{x,0},_,{y,0}]) -> 8;
fit_args(put_list, [{x,_},nil,{x,_}]) -> 6;
fit_args(put_list, [{x,_},{x,_},{x,_}]) -> 2;
fit_args(put_list, [{x,_},_,{y,Arg2}]) when Arg2 >= 0, Arg2 =< 255 -> 11;
fit_args(put_list, [_,{x,0},_]) -> 9;
fit_args(put_list, [_,nil,_]) -> 13;
fit_args(put_list, [_,_,{x,0}]) -> 0;
fit_args(put_list, [_,_,{x,1}]) -> 1;
fit_args(put_list, [_,_,{x,2}]) -> 3;
fit_args(put_list, [_,_,{x,3}]) -> 4;
fit_args(put_list, [_,_,{x,4}]) -> 5;
fit_args(put_list, [_,_,{x,5}]) -> 7;
fit_args(put_list, [_,_,{x,6}]) -> 10;
fit_args(put_list, [_,_,_]) -> 14;
fit_args(raise, [{x,2},{x,1}]) -> 0;
fit_args(raise, [_,_]) -> 1;
fit_args(recv_mark, [{f,_}]) -> 0;
fit_args(remove_message, []) -> 0;
fit_args(return, []) -> 0;
fit_args(self, [{x,0}]) -> 0;
fit_args(self, [{x,1}]) -> 1;
fit_args(self, [{x,2}]) -> 2;
fit_args(self, [{x,3}]) -> 3;
fit_args(self, [{y,0}]) -> 4;
fit_args(self, [_]) -> 5;
fit_args(send, []) -> 0;
fit_args(set_tuple_element, [{y,Arg0},{x,0},Arg2]) when Arg0 >= 0, Arg0 =< 255, Arg2 >= 0, Arg2 =< 255 -> 0;
fit_args(set_tuple_element, [_,{x,0},_]) -> 1;
fit_args(set_tuple_element, [_,_,_]) -> 2;
fit_args(system_limit, [{f,_}]) -> 0;
fit_args(test_arity, [{f,_},{x,0},2]) -> 0;
fit_args(test_arity, [{f,_},{x,0},_]) -> 2;
fit_args(test_arity, [{f,_},{x,_},Arg2]) when Arg2 >= 0, Arg2 =< 255 -> 1;
fit_args(test_arity, [{f,_},{y,Arg1},Arg2]) when Arg1 >= 0, Arg1 =< 255, Arg2 >= 0, Arg2 =< 255 -> 3;
fit_args(test_arity, [{f,_},_,_]) -> 4;
fit_args(test_heap, [HeapNeeded,Live]) when HeapNeeded >= 0, HeapNeeded =< 255, Live >= 0, Live =< 255 -> 0;
fit_args(test_heap, [_,Live]) when Live >= 0, Live =< 255 -> 1;
fit_args(test_heap_1_put_list, [2,{y,0}]) -> 0;
fit_args(test_heap_1_put_list, [2,_]) -> 1;
fit_args(test_heap_1_put_list, [Arg0,{i,Arg1}]) when Arg0 >= 0, Arg0 =< 255, Arg1 >= -128, Arg1 =< 127 -> 3;
fit_args(test_heap_1_put_list, [Arg0,{y,Arg1}]) when Arg0 >= 0, Arg0 =< 255, Arg1 >= 0, Arg1 =< 255 -> 2;
fit_args(test_heap_1_put_list, [_,_]) -> 4;
fit_args(timeout, []) -> 0;
fit_args(try_case_end, [{x,0}]) -> 0;
fit_args(try_case_end, [_]) -> 1;
fit_args(try_end, [{y,0}]) -> 0;
fit_args(try_end, [{y,1}]) -> 1;
fit_args(try_end, [{y,2}]) -> 2;
fit_args(try_end, [{y,4}]) -> 3;
fit_args(try_end, [{y,3}]) -> 5;
fit_args(try_end, [{y,5}]) -> 4;
fit_args(try_end, [{y,6}]) -> 6;
fit_args(try_end, [_]) -> 7;
fit_args(wait, [{f,_}]) -> 0;
fit_args(wait_timeout, [{f,_},_]) -> 0;
fit_args(Op, As) -> erlang:error({nofit,Op,As}).

var_args(move, 0) -> [t,{x,1}];
var_args(move, 1) -> [t,{x,0}];
var_args(l_call, 0) -> [f];
var_args(test_heap, 0) -> [u8,u8];
var_args(move, 2) -> [t,{x,2}];
var_args(badmatch, 0) -> [{x,0}];
var_args(move, 3) -> [x8,y8];
var_args(l_put_tuple, 0) -> [x8,u8];
var_args(move, 4) -> [{x,0},t];
var_args(move2, 1) -> [y8,x8,y8,t];
var_args(get_tuple_element, 0) -> [{x,0},u8,x8];
var_args(move2, 0) -> [x8,y8,x8,y8];
var_args(put_list, 0) -> [t,t,{x,0}];
var_args(is_tuple_of_arity, 1) -> [f,x8,u8];
var_args(get_tuple_element, 1) -> [x8,u8,x8];
var_args(l_call_only, 0) -> [f];
var_args(call_bif, 7) -> [{b,{erlang,iolist_to_binary,1}}];
var_args(l_bs_start_match2, 0) -> [{x,0},f,{u8,1},{u,0},{x,1}];
var_args(l_bs_test_zero_tail2, 0) -> [f,{x,1}];
var_args(l_bs_match_string, 0) -> [{x,1},f,u32,str];
var_args(l_is_eq_exact_immed, 0) -> [f,{x,1},t];
var_args(put_list, 1) -> [t,t,{x,1}];
var_args(is_tuple_of_arity, 0) -> [f,{x,0},{u,2}];
var_args(l_is_eq_exact_immed, 1) -> [f,{x,0},t];
var_args(get_list, 0) -> [x8,x8,x8];
var_args(l_put_tuple, 1) -> [{x,0},{u,2}];
var_args(move, 5) -> [t,{x,3}];
var_args(l_call_ext, 85) -> [e];
var_args(l_move_call_ext, 0) -> [t,{e,{re,split,3}}];
var_args(return, 0) -> [];
var_args(move2, 2) -> [x8,x8,x8,t];
var_args(l_is_ge, 0) -> [f];
var_args(l_move_call_last, 0) -> [f,u8,y8];
var_args(l_make_fun, 0) -> [fu];
var_args(is_tuple_of_arity, 2) -> [f,{x,0},u32];
var_args(extract_next_element2, 0) -> [{x,1}];
var_args(move_deallocate_return, 0) -> [x8,u8];
var_args(call_bif, 3) -> [{b,{erlang,error,1}}];
var_args(l_allocate, 0) -> [{u,1}];
var_args(l_fetch, 0) -> [{x,0},t];
var_args(l_trim, 0) -> [{u,1}];
var_args(is_nil, 0) -> [f,{x,0}];
var_args(is_nonempty_list, 0) -> [f,{x,0}];
var_args(move_return, 25) -> [t];
var_args(l_move_call_ext, 1) -> [t,{e,{re,replace,4}}];
var_args(deallocate_return, 0) -> [{u,1}];
var_args(case_end, 0) -> [{x,0}];
var_args(get_list, 1) -> [{x,0},x8,x8];
var_args(l_allocate, 1) -> [{u,0}];
var_args(l_fetch, 1) -> [t,{x,0}];
var_args(jump, 0) -> [f];
var_args(extract_next_element, 0) -> [{x,1}];
var_args(put_list, 3) -> [t,t,{x,2}];
var_args(l_is_eq_exact_immed, 2) -> [f,{x,3},t];
var_args(move2, 3) -> [x8,y8,{x,0},y8];
var_args(l_fetch, 2) -> [x8,x8];
var_args(l_is_eq_exact, 0) -> [f];
var_args(call_bif, 8) -> [{b,{erlang,setelement,3}}];
var_args(l_allocate, 2) -> [{u,2}];
var_args(l_is_eq_exact_immed, 3) -> [f,{x,2},t];
var_args(get_tuple_element, 2) -> [t,{u,0},{x,0}];
var_args(l_move_call, 26) -> [t,f];
var_args(deallocate_return, 1) -> [{u,0}];
var_args(move_return, 0) -> [{a,true}];
var_args(init2, 0) -> [y8,y8];
var_args(get_tuple_element, 3) -> [{x,0},u8,y8];
var_args(put_list, 2) -> [x8,x8,x8];
var_args(init, 0) -> [{y,1}];
var_args(move2, 4) -> [{x,0},y8,x8,y8];
var_args(l_is_eq_exact_immed, 4) -> [f,x8,i8];
var_args(call_bif, 9) -> [{b,{erlang,'++',2}}];
var_args(l_fetch, 3) -> [x8,i8];
var_args(deallocate_return, 2) -> [{u,2}];
var_args(extract_next_element, 1) -> [{x,3}];
var_args(is_nonempty_list, 1) -> [f,{x,2}];
var_args(put_list, 4) -> [t,t,{x,3}];
var_args(l_put_tuple, 2) -> [{x,0},{u,3}];
var_args(l_allocate, 3) -> [{u,3}];
var_args(is_tuple_of_arity, 3) -> [f,y8,u8];
var_args(move2, 5) -> [x8,{x,0},x8,x8];
var_args(init, 1) -> [{y,0}];
var_args(get_tuple_element, 4) -> [y8,u8,x8];
var_args(l_fetch, 4) -> [x8,y8];
var_args(init3, 0) -> [y8,y8,y8];
var_args(get_list, 2) -> [x8,{x,0},x8];
var_args(l_move_call_ext, 38) -> [t,e];
var_args(allocate_init, 0) -> [u32,{y,0}];
var_args(l_is_eq_exact_immed, 5) -> [f,{x,4},t];
var_args(l_trim, 1) -> [{u,2}];
var_args(test_heap_1_put_list, 0) -> [{u,2},{y,0}];
var_args(l_is_lt, 0) -> [f];
var_args(l_is_eq_exact_literal, 0) -> [f,{x,0},t];
var_args(call_bif, 6) -> [{b,{erlang,throw,1}}];
var_args(call_bif, 45) -> [b];
var_args(l_allocate_zero, 0) -> [{u,2}];
var_args(allocate_heap, 0) -> [u8,u8,u8];
var_args(is_tuple, 0) -> [f,{x,0}];
var_args(move_return, 1) -> [{x,1}];
var_args(is_nonempty_list, 2) -> [f,{x,1}];
var_args(l_allocate_zero, 1) -> [{u,1}];
var_args(move, 6) -> [t,{x,4}];
var_args(l_call_last, 0) -> [f,{u,2}];
var_args(init, 2) -> [{y,2}];
var_args(l_gc_bif1, 0) -> [f,b,t,u8,x8];
var_args(deallocate_return, 3) -> [{u,3}];
var_args(get_tuple_element, 5) -> [x8,u8,y8];
var_args(l_increment, 0) -> [x8,u8,u8,t];
var_args(call_bif, 2) -> [{b,{erlang,error,2}}];
var_args(is_nonempty_list_allocate, 0) -> [f,{x,0},u32];
var_args(l_select_val_atoms, 0) -> [x8,f,u8];
var_args(l_move_call, 0) -> [{x,2},f];
var_args(l_is_eq_exact_immed, 6) -> [f,{x,5},t];
var_args(call_bif, 5) -> [{b,{erlang,exit,1}}];
var_args(move_deallocate_return, 1) -> [{a,ok},u32];
var_args(is_nonempty_list, 3) -> [f,{x,3}];
var_args(extract_next_element, 2) -> [{x,2}];
var_args(is_list, 0) -> [f,{x,0}];
var_args(l_select_val2, 3) -> [{x,1},f,t,f,t,f];
var_args(l_fetch, 5) -> [i8,x8];
var_args(extract_next_element3, 0) -> [{x,1}];
var_args(is_nil, 1) -> [f,{x,2}];
var_args(move_deallocate_return, 2) -> [y8,u8];
var_args(l_call_last, 1) -> [f,{u,0}];
var_args(l_trim, 2) -> [{u,3}];
var_args(l_call_last, 2) -> [f,{u,3}];
var_args(get_list, 3) -> [{x,0},{x,0},t];
var_args(l_select_val2, 0) -> [{x,0},f,{a,false},f,{a,true},f];
var_args(l_move_call_only, 12) -> [f,t];
var_args(is_nil, 2) -> [f,{x,1}];
var_args(move2, 6) -> [{x,0},x8,x8,{x,0}];
var_args(l_allocate, 4) -> [{u,4}];
var_args(l_move_call_only, 0) -> [f,{x,2}];
var_args(extract_next_element2, 1) -> [{x,3}];
var_args(move_return, 2) -> [{x,2}];
var_args(test_arity, 0) -> [f,{x,0},{u,2}];
var_args(move2, 7) -> [x8,x8,{x,0},x8];
var_args(l_call_ext, 0) -> [{e,{lists,reverse,1}}];
var_args(l_new_bs_put_integer_imm, 0) -> [f,u8,u8,t];
var_args(l_select_val2, 4) -> [{x,0},f,t,f,t,f];
var_args(l_move_call_only, 1) -> [f,{x,1}];
var_args(l_select_val2, 1) -> [{x,0},f,{a,true},f,{a,false},f];
var_args(remove_message, 0) -> [];
var_args(init, 3) -> [{y,3}];
var_args(l_allocate_zero, 2) -> [{u,3}];
var_args(l_plus, 0) -> [f,u8,x8];
var_args(l_catch, 0) -> [{y,0},t];
var_args(deallocate_return, 4) -> [{u,4}];
var_args(is_nonempty_list, 4) -> [f,{x,7}];
var_args(bif1_body, 0) -> [{b,{erlang,hd,1}},t,{x,0}];
var_args(l_put_tuple, 3) -> [{x,0},{u,4}];
var_args(extract_next_element, 3) -> [{x,4}];
var_args(l_is_eq_exact_immed, 7) -> [f,{x,6},t];
var_args(move_jump, 14) -> [f,t];
var_args(move, 7) -> [y8,y8];
var_args(l_allocate_zero, 3) -> [{u,4}];
var_args(l_move_call_only, 2) -> [f,{x,4}];
var_args(l_select_tuple_arity2, 0) -> [{x,0},f,u8,f,u8,f];
var_args(l_bs_start_match2, 1) -> [t,f,u8,u8,x8];
var_args(catch_end, 0) -> [{y,0}];
var_args(move_return, 3) -> [nil];
var_args(is_nonempty_list, 5) -> [f,{x,4}];
var_args(l_is_eq_exact_immed, 8) -> [f,{x,7},t];
var_args(l_call_last, 3) -> [f,{u,1}];
var_args(l_move_call_only, 3) -> [f,{x,3}];
var_args(l_call_last, 4) -> [f,{u,4}];
var_args(get_list, 4) -> [t,x8,y8];
var_args(move_return, 4) -> [{a,false}];
var_args(move, 8) -> [t,{x,5}];
var_args(test_arity, 1) -> [f,x8,u8];
var_args(move_return, 5) -> [{a,ok}];
var_args(is_nonempty_list, 6) -> [f,{x,5}];
var_args(l_call_fun, 0) -> [{u8,1}];
var_args(l_increment, 1) -> [y8,u8,u8,t];
var_args(put_list, 5) -> [t,t,{x,4}];
var_args(init, 4) -> [{y,4}];
var_args(l_is_eq, 0) -> [f];
var_args(l_select_val2, 2) -> [x8,f,i8,f,i8,f];
var_args(l_move_call_ext, 2) -> [t,{e,{io,format,2}}];
var_args(l_call_ext_only, 4) -> [e];
var_args(l_bs_get_binary_all_reuse, 0) -> [t,f,{u8,8}];
var_args(send, 0) -> [];
var_args(set_tuple_element, 0) -> [y8,{x,0},u8];
var_args(bif2_body, 0) -> [b,{x,0}];
var_args(extract_next_element2, 2) -> [{x,2}];
var_args(l_move_call, 1) -> [{x,1},f];
var_args(l_catch, 1) -> [{y,1},t];
var_args(is_nil, 3) -> [f,{x,4}];
var_args(move_deallocate_return, 3) -> [t,{u,0}];
var_args(call_bif, 10) -> [{b,{lists,member,2}}];
var_args(extract_next_element2, 3) -> [{x,4}];
var_args(badmatch, 1) -> [{x,3}];
var_args(is_nonempty_list, 7) -> [f,{x,6}];
var_args(l_increment, 2) -> [t,{u,4294967295},u8,x8];
var_args(l_is_eq_exact_immed, 9) -> [f,{x,8},t];
var_args(case_end, 1) -> [{x,1}];
var_args(extract_next_element, 4) -> [{x,5}];
var_args(l_trim, 3) -> [{u,4}];
var_args(l_move_call_ext_last, 0) -> [e,u8,y8];
var_args(is_nonempty_list, 8) -> [f,{x,9}];
var_args(l_move_call_last, 1) -> [f,{u,1},t];
var_args(badmatch, 2) -> [{x,2}];
var_args(deallocate_return, 5) -> [{u,5}];
var_args(l_fetch, 6) -> [y8,y8];
var_args(l_select_val_atoms, 1) -> [{x,0},f,u32];
var_args(l_bs_add, 0) -> [f,{u8,1},t];
var_args(l_allocate, 5) -> [{u,5}];
var_args(l_select_val_smallints, 0) -> [x8,f,u8];
var_args(l_move_call, 2) -> [{y,2},f];
var_args(l_select_tuple_arity2, 1) -> [x8,f,u8,f,u8,f];
var_args(is_nonempty_list, 9) -> [f,{x,8}];
var_args(l_bs_test_zero_tail2, 1) -> [f,{x,2}];
var_args(l_loop_rec, 0) -> [f];
var_args(l_move_call_ext, 3) -> [{y,0},e];
var_args(is_nil, 4) -> [f,{x,3}];
var_args(l_is_ne_exact_immed, 0) -> [f,{x,0},t];
var_args(l_increment, 3) -> [{x,0},u32,u8,{x,0}];
var_args(l_is_ne, 0) -> [f];
var_args(l_move_call, 3) -> [{y,0},f];
var_args(l_plus, 1) -> [f,u8,{x,0}];
var_args(catch_end, 1) -> [{y,1}];
var_args(l_move_call, 4) -> [{y,1},f];
var_args(init, 5) -> [{y,5}];
var_args(l_call_last, 6) -> [f,{u,6}];
var_args(l_call_last, 5) -> [f,{u,5}];
var_args(l_minus, 0) -> [f,u8,x8];
var_args(l_move_call_ext, 4) -> [{y,1},e];
var_args(l_bs_match_string, 1) -> [t,f,{u,8},str];
var_args(l_allocate_zero, 4) -> [{u,6}];
var_args(extract_next_element, 5) -> [{x,6}];
var_args(l_select_val2, 6) -> [{x,2},f,t,f,t,f];
var_args(l_bs_init_heap_bin, 0) -> [u8,u8,u8,t];
var_args(l_allocate_zero, 5) -> [{u,5}];
var_args(l_bs_start_match2, 2) -> [{x,0},f,u8,u8,{x,0}];
var_args(l_fetch, 7) -> [y8,x8];
var_args(l_call_ext_last, 0) -> [e,{u,1}];
var_args(is_nonempty_list_allocate, 1) -> [f,x8,u8];
var_args(l_bs_restore2, 0) -> [x8,u8];
var_args(loop_rec_end, 0) -> [f];
var_args(call_bif, 11) -> [{b,{ets,insert,2}}];
var_args(l_bs_get_utf16, 0) -> [x8,f,u8,x8];
var_args(l_fast_element, 1) -> [t,u8,x8];
var_args(l_gc_bif1, 1) -> [f,{b,{erlang,length,1}},t,u8,{x,0}];
var_args(l_trim, 4) -> [{u,5}];
var_args(move, 9) -> [t,{x,6}];
var_args(wait, 0) -> [f];
var_args(l_is_eq_exact_immed, 10) -> [f,{x,9},t];
var_args(extract_next_element2, 4) -> [{x,5}];
var_args(is_atom, 0) -> [f,{x,0}];
var_args(call_bif, 12) -> [{b,{erlang,get_module_info,2}}];
var_args(int_code_end, 0) -> [];
var_args(l_call_fun_last, 0) -> [u8,u8];
var_args(l_move_call_ext_only, 0) -> [{e,{erlang,get_module_info,1}},t];
var_args(get_tuple_element, 6) -> [{x,0},{u,1},{x,0}];
var_args(move_deallocate_return, 4) -> [t,{u,1}];
var_args(bs_context_to_binary, 0) -> [{x,0}];
var_args(init, 6) -> [{y,6}];
var_args(l_move_call_ext, 5) -> [{y,2},e];
var_args(extract_next_element, 6) -> [{x,255}];
var_args(self, 0) -> [{x,0}];
var_args(is_nil, 5) -> [f,{x,5}];
var_args(l_move_call_ext, 6) -> [{y,3},e];
var_args(l_call_ext_last, 1) -> [e,{u,0}];
var_args(l_call_fun, 1) -> [{u8,2}];
var_args(l_is_eq_exact_immed, 11) -> [f,{x,255},t];
var_args(l_move_call, 5) -> [{y,3},f];
var_args(l_is_ne_exact_immed, 1) -> [f,{x,1},t];
var_args(is_tuple, 1) -> [f,{x,1}];
var_args(extract_next_element, 7) -> [{x,7}];
var_args(l_move_call_last, 2) -> [f,u8,x8];
var_args(l_times, 0) -> [f,u8,x8];
var_args(l_bs_test_unit_8, 0) -> [f,{x,0}];
var_args(l_allocate, 6) -> [{u,6}];
var_args(badmatch, 3) -> [{x,1}];
var_args(l_move_call_ext_only, 1) -> [{e,{io_lib,format,2}},t];
var_args(l_bs_test_zero_tail2, 2) -> [f,{x,0}];
var_args(l_move_call_ext, 7) -> [{y,4},e];
var_args(l_move_call_ext, 8) -> [{smallint,1},e];
var_args(move_return, 6) -> [{x,3}];
var_args(l_put_tuple, 4) -> [{x,0},{u,5}];
var_args(call_bif, 13) -> [{b,{erlang,binary_to_list,1}}];
var_args(l_catch, 2) -> [{y,2},t];
var_args(bif1_body, 1) -> [b,{x,0},t];
var_args(l_select_val_smallints, 1) -> [{x,0},f,u32];
var_args(raise, 0) -> [{x,2},{x,1}];
var_args(call_bif, 14) -> [{b,{erlang,list_to_binary,1}}];
var_args(is_nil, 6) -> [f,{x,6}];
var_args(l_move_call, 6) -> [{x,3},f];
var_args(l_move_call_ext, 9) -> [{x,2},e];
var_args(l_select_val2, 7) -> [{x,3},f,t,f,t,f];
var_args(is_integer, 0) -> [f,{x,0}];
var_args(extract_next_element3, 1) -> [{x,3}];
var_args(l_minus, 1) -> [f,u8,{x,0}];
var_args(is_nonempty_list, 10) -> [f,{x,10}];
var_args(call_bif, 15) -> [{b,{ets,delete,1}}];
var_args(l_bs_save2, 0) -> [x8,u8];
var_args(l_call_ext_last, 2) -> [e,{u,2}];
var_args(extract_next_element, 8) -> [{y,1}];
var_args(l_call_ext, 1) -> [{e,{asn1ct_gen,emit,1}}];
var_args(l_new_bs_put_binary_all, 0) -> [f,t,{u8,8}];
var_args(l_move_call_ext_only, 7) -> [e,t];
var_args(is_nil, 7) -> [f,{x,7}];
var_args(deallocate_return, 6) -> [{u,6}];
var_args(l_move_call_only, 4) -> [f,{x,5}];
var_args(self, 1) -> [{x,1}];
var_args(l_call_ext, 2) -> [{e,{file,close,1}}];
var_args(l_select_val2, 5) -> [t,f,{a,true},f,{a,false},f];
var_args(case_end, 2) -> [{x,2}];
var_args(allocate_heap_zero, 0) -> [u8,u8,u8];
var_args(call_bif, 16) -> [{b,{lists,keysearch,3}}];
var_args(is_nonempty_list, 11) -> [f,{x,11}];
var_args(extract_next_element2, 5) -> [{x,6}];
var_args(apply, 0) -> [u8];
var_args(try_end, 0) -> [{y,0}];
var_args(l_move_call, 7) -> [{y,5},f];
var_args(call_bif, 17) -> [{b,{ets,lookup,2}}];
var_args(l_fast_element, 0) -> [{x,0},{u,2},{x,0}];
var_args(test_heap_1_put_list, 1) -> [{u,2},t];
var_args(call_bif, 19) -> [{b,{erlang,integer_to_list,1}}];
var_args(call_bif, 18) -> [{b,{lists,reverse,2}}];
var_args(call_bif, 20) -> [{b,{erlang,atom_to_list,1}}];
var_args(l_bs_test_zero_tail2, 3) -> [f,{x,3}];
var_args(l_move_call_ext, 10) -> [{x,1},e];
var_args(is_nil, 8) -> [f,{x,8}];
var_args(get_tuple_element, 7) -> [x8,u8,{x,0}];
var_args(call_bif, 21) -> [{b,{erlang,list_to_atom,1}}];
var_args(l_call_ext, 3) -> [{e,{lists,foreach,2}}];
var_args(catch_end, 2) -> [{y,2}];
var_args(l_put_tuple, 5) -> [{x,0},u8];
var_args(is_list, 1) -> [f,{x,1}];
var_args(extract_next_element3, 2) -> [{x,2}];
var_args(get_list, 7) -> [t,{x,0},t];
var_args(l_bif2, 0) -> [f,{b,{erlang,element,2}},t];
var_args(call_bif, 22) -> [{b,{ets,info,2}}];
var_args(init, 7) -> [{y,7}];
var_args(try_end, 1) -> [{y,1}];
var_args(l_bs_get_integer_32, 0) -> [x8,f,u8,x8];
var_args(test_arity, 2) -> [f,{x,0},u32];
var_args(l_trim, 5) -> [{u,6}];
var_args(l_increment, 4) -> [t,{u,4294967295},u8,{x,0}];
var_args(l_move_call, 8) -> [{y,4},f];
var_args(l_call_ext, 4) -> [{e,{lists,foldl,3}}];
var_args(extract_next_element, 9) -> [{y,0}];
var_args(l_move_call_ext, 11) -> [t,{e,{io_lib,format,2}}];
var_args(l_is_ne_exact, 0) -> [f];
var_args(l_bs_get_binary2, 0) -> [f,t,u8,x8,u8,{u8,0},x8];
var_args(extract_next_element, 24) -> [t];
var_args(is_integer, 1) -> [f,{x,1}];
var_args(l_band, 0) -> [f,u8,x8];
var_args(move_jump, 0) -> [f,{x,1}];
var_args(l_is_eq_exact_immed, 12) -> [f,{x,10},t];
var_args(l_call_fun, 2) -> [{u8,3}];
var_args(move_deallocate_return, 5) -> [t,{u,2}];
var_args(l_times, 1) -> [f,u8,{x,0}];
var_args(l_move_call_last, 3) -> [f,{u,2},t];
var_args(put_list, 7) -> [t,t,{x,5}];
var_args(l_call_last, 7) -> [f,{u,7}];
var_args(l_move_call_ext_only, 3) -> [{e,{lists,reverse,1}},x8];
var_args(l_fast_element, 2) -> [t,u8,{x,0}];
var_args(l_is_eq_exact_literal, 7) -> [f,t,t];
var_args(extract_next_element, 10) -> [{x,8}];
var_args(extract_next_element2, 6) -> [{x,7}];
var_args(is_tuple, 2) -> [f,{x,2}];
var_args(l_catch, 3) -> [{y,3},t];
var_args(l_call_ext, 5) -> [{e,{lists,sort,1}}];
var_args(l_call_ext, 6) -> [{e,{file,open,2}}];
var_args(l_bif2, 1) -> [f,{b,{erlang,'=:=',2}},t];
var_args(l_is_eq_exact_immed, 13) -> [f,{x,11},t];
var_args(is_binary, 0) -> [f,{x,0}];
var_args(l_call_ext, 7) -> [{e,{lists,map,2}}];
var_args(extract_next_element2, 7) -> [{x,8}];
var_args(l_allocate_zero, 6) -> [{u,7}];
var_args(l_bsr, 0) -> [f,u8,x8];
var_args(l_fetch, 22) -> [t,t];
var_args(move, 10) -> [t,{x,7}];
var_args(extract_next_element3, 3) -> [{x,5}];
var_args(l_is_eq_exact_immed, 14) -> [f,{y,1},t];
var_args(get_list, 5) -> [{x,0},t,{x,0}];
var_args(is_atom, 1) -> [f,{x,1}];
var_args(extract_next_element3, 4) -> [{x,4}];
var_args(l_bs_get_binary_all2, 0) -> [f,x8,u8,u8,x8];
var_args(call_bif, 23) -> [{b,{erlang,tuple_to_list,1}}];
var_args(l_move_call_only, 5) -> [f,{x,6}];
var_args(call_bif, 24) -> [{b,{erlang,list_to_tuple,1}}];
var_args(is_nonempty_list, 12) -> [f,{x,12}];
var_args(l_is_eq_exact_immed, 15) -> [f,{x,12},t];
var_args(l_fetch, 8) -> [y8,i8];
var_args(l_is_eq_exact_literal, 1) -> [f,{x,1},t];
var_args(l_move_call_ext, 12) -> [t,{e,{asn1ct_gen,emit,1}}];
var_args(l_bs_get_integer_8, 0) -> [{x,0},f,x8];
var_args(l_is_ne_exact_immed, 2) -> [f,{x,2},t];
var_args(put_list, 6) -> [x8,nil,x8];
var_args(is_nil, 9) -> [f,{x,9}];
var_args(l_bsl, 0) -> [f,u8,{x,0}];
var_args(l_select_val2, 9) -> [{x,4},f,t,f,t,f];
var_args(is_list, 2) -> [f,{x,2}];
var_args(l_allocate_zero, 9) -> [u32];
var_args(l_put_tuple, 6) -> [y8,u8];
var_args(l_call_ext, 8) -> [{e,{filename,join,2}}];
var_args(l_bs_init_fail, 0) -> [u8,f,u8,x8];
var_args(get_list, 6) -> [y8,x8,x8];
var_args(l_bif2, 2) -> [f,{b,{erlang,'=<',2}},t];
var_args(deallocate_return, 7) -> [{u,7}];
var_args(l_bs_get_integer_8, 1) -> [x8,f,x8];
var_args(set_tuple_element, 1) -> [t,{x,0},u32];
var_args(l_move_call_ext, 13) -> [{y,6},e];
var_args(l_select_val2, 16) -> [t,f,t,f,t,f];
var_args(call_bif, 26) -> [{b,{erlang,'--',2}}];
var_args(call_bif, 25) -> [{b,{lists,keyfind,3}}];
var_args(l_call_ext, 9) -> [{e,{lists,flatten,1}}];
var_args(l_move_call, 9) -> [{smallint,1},f];
var_args(l_is_eq_exact_literal, 2) -> [f,{x,4},t];
var_args(l_bs_get_integer_32, 1) -> [{x,0},f,u8,x8];
var_args(extract_next_element, 11) -> [{x,9}];
var_args(l_is_eq_exact_literal, 3) -> [f,{x,2},t];
var_args(l_is_eq_exact_immed, 16) -> [f,{y,0},t];
var_args(l_fetch, 9) -> [{x,1},t];
var_args(l_bif2, 3) -> [f,{b,{erlang,'and',2}},t];
var_args(is_nil, 10) -> [f,{x,10}];
var_args(l_bsl, 1) -> [f,u8,x8];
var_args(l_bs_test_zero_tail2, 5) -> [f,t];
var_args(l_trim, 6) -> [{u,7}];
var_args(l_rem, 0) -> [f,u8,x8];
var_args(move2, 8) -> [{x,0},x8,x8,x8];
var_args(l_move_call_ext, 14) -> [t,{e,{erlang,put,2}}];
var_args(timeout, 0) -> [];
var_args(is_binary, 1) -> [f,{x,1}];
var_args(catch_end, 3) -> [{y,3}];
var_args(l_move_call_ext_last, 1) -> [e,{u,0},t];
var_args(l_call_last, 8) -> [f,{u,8}];
var_args(l_allocate_zero, 7) -> [{u,8}];
var_args(l_select_val2, 10) -> [{x,5},f,t,f,t,f];
var_args(l_fetch, 10) -> [i8,y8];
var_args(l_fmul, 0) -> [fr,fr,fr];
var_args(l_bs_match_string, 2) -> [{x,0},f,u32,str];
var_args(call_bif, 27) -> [{b,{ets,lookup_element,3}}];
var_args(extract_next_element3, 10) -> [t];
var_args(l_gc_bif1, 2) -> [f,{b,{erlang,byte_size,1}},x8,u8,{x,0}];
var_args(move_deallocate_return, 6) -> [t,{u,3}];
var_args(l_allocate, 7) -> [{u,7}];
var_args(l_move_call, 10) -> [{y,6},f];
var_args(l_catch, 4) -> [{y,4},t];
var_args(is_nonempty_list, 36) -> [f,t];
var_args(l_bs_get_integer_small_imm, 0) -> [{x,0},u8,f,u8,x8];
var_args(extract_next_element, 12) -> [{y,2}];
var_args(l_is_eq_exact_immed, 36) -> [f,t,t];
var_args(l_call_ext, 10) -> [{e,{ordsets,union,2}}];
var_args(move_jump, 1) -> [f,{x,2}];
var_args(l_fcheckerror, 0) -> [];
var_args(fclearerror, 0) -> [];
var_args(move_return, 7) -> [{x,4}];
var_args(l_bs_append, 0) -> [f,u8,u8,u8,x8];
var_args(node, 0) -> [{x,0}];
var_args(l_move_call, 11) -> [{x,4},f];
var_args(extract_next_element2, 16) -> [t];
var_args(l_move_call_last, 4) -> [f,{u,0},t];
var_args(l_is_eq_exact_immed, 17) -> [f,{x,13},t];
var_args(l_call_ext, 11) -> [{e,{lists,concat,1}}];
var_args(extract_next_element, 13) -> [{y,3}];
var_args(l_move_call_ext_only, 2) -> [{e,{erlang,nif_error,1}},{a,undef}];
var_args(l_is_ne_exact_immed, 11) -> [f,t,t];
var_args(l_is_eq_exact_immed, 18) -> [f,{y,3},t];
var_args(l_get, 1) -> [t,{x,0}];
var_args(l_element, 2) -> [t,t,{x,0}];
var_args(is_integer, 2) -> [f,{x,2}];
var_args(is_integer, 7) -> [f,t];
var_args(l_move_call_ext_last, 4) -> [e,u32,t];
var_args(l_bif2, 4) -> [f,{b,{erlang,'or',2}},t];
var_args(l_move_call_ext, 16) -> [{x,3},e];
var_args(l_call_fun, 3) -> [{u8,0}];
var_args(l_move_call, 12) -> [{x,5},f];
var_args(call_bif, 28) -> [{b,{erlang,process_flag,2}}];
var_args(is_nonempty_list, 13) -> [f,{x,13}];
var_args(try_end, 2) -> [{y,2}];
var_args(is_nil, 11) -> [f,{x,12}];
var_args(l_select_tuple_arity, 1) -> [x8,f,u8];
var_args(is_tuple, 3) -> [f,{x,3}];
var_args(l_move_call_ext_last, 2) -> [e,{u,1},t];
var_args(node, 1) -> [{x,1}];
var_args(is_nonempty_list, 14) -> [f,{y,2}];
var_args(l_bs_restore2, 1) -> [{x,0},{u,0}];
var_args(l_move_call_ext, 17) -> [{y,5},e];
var_args(l_band, 1) -> [f,u8,{x,0}];
var_args(l_is_eq_exact_immed, 19) -> [f,{y,2},t];
var_args(l_get, 4) -> [t,t];
var_args(call_bif, 29) -> [{b,{re,run,3}}];
var_args(call_bif, 1) -> [{b,{erlang,raise,3}}];
var_args(l_fetch, 11) -> [t,{x,1}];
var_args(l_gc_bif1, 3) -> [f,b,{x,0},{u8,1},{x,0}];
var_args(is_nil, 12) -> [f,{x,11}];
var_args(l_move_call_only, 6) -> [f,{x,7}];
var_args(l_move_call, 13) -> [nil,f];
var_args(system_limit, 0) -> [f];
var_args(l_element, 0) -> [x8,{x,0},x8];
var_args(l_select_tuple_arity, 0) -> [{x,0},f,{u,6}];
var_args(bif2_body, 1) -> [b,{x,1}];
var_args(is_float, 1) -> [f,t];
var_args(extract_next_element2, 8) -> [{x,9}];
var_args(l_select_val2, 8) -> [t,f,{a,false},f,{a,true},f];
var_args(is_integer_allocate, 0) -> [f,x8,u8];
var_args(is_atom, 2) -> [f,{x,2}];
var_args(l_int_div, 0) -> [f,u8,x8];
var_args(l_get, 2) -> [t,{x,1}];
var_args(l_gc_bif1, 5) -> [f,b,t,u8,{x,0}];
var_args(l_move_call_ext, 18) -> [t,{e,{prettypr,text,1}}];
var_args(is_nil, 29) -> [f,t];
var_args(l_is_eq_exact_immed, 20) -> [f,{y,4},t];
var_args(call_bif, 30) -> [{b,{ets,new,2}}];
var_args(l_bor, 0) -> [f,u8,{x,0}];
var_args(l_bif1, 0) -> [f,b,x8,x8];
var_args(l_catch, 5) -> [{y,5},t];
var_args(l_get, 0) -> [{a,asn1_module},{y,0}];
var_args(l_fetch, 12) -> [{x,2},t];
var_args(l_call_ext, 13) -> [{e,{file,delete,1}}];
var_args(l_call_ext, 12) -> [{e,{test_server,timetrap,1}}];
var_args(is_tuple, 9) -> [f,t];
var_args(try_end, 3) -> [{y,4}];
var_args(init, 8) -> [{y,8}];
var_args(call_bif, 32) -> [{b,{erlang,make_ref,0}}];
var_args(call_bif, 31) -> [{b,{erlang,whereis,1}}];
var_args(is_nil, 13) -> [f,{y,1}];
var_args(apply_last, 0) -> [u8,u32];
var_args(call_bif, 33) -> [{b,{erlang,process_info,2}}];
var_args(l_int_div, 1) -> [f,u8,{x,0}];
var_args(call_bif, 34) -> [{b,{erlang,unlink,1}}];
var_args(extract_next_element, 14) -> [{x,10}];
var_args(put_list, 9) -> [t,{x,0},t];
var_args(is_nonempty_list, 15) -> [f,{y,3}];
var_args(case_end, 11) -> [t];
var_args(l_bs_skip_bits2, 0) -> [f,t,t,u8];
var_args(l_call_ext, 14) -> [{e,{test_server,timetrap_cancel,1}}];
var_args(deallocate_return, 8) -> [{u,8}];
var_args(l_call_ext_last, 3) -> [e,{u,3}];
var_args(l_move_call_ext, 19) -> [t,{e,{proplists,get_value,3}}];
var_args(l_is_ne_exact_immed, 3) -> [f,{x,3},t];
var_args(extract_next_element3, 5) -> [{x,6}];
var_args(is_integer, 3) -> [f,{x,3}];
var_args(l_trim, 7) -> [{u,8}];
var_args(l_is_eq_exact_immed, 21) -> [f,{x,14},t];
var_args(l_increment, 8) -> [t,u32,u8,t];
var_args(call_bif, 4) -> [{b,{erlang,exit,2}}];
var_args(is_nonempty_list, 16) -> [f,{x,14}];
var_args(is_list, 7) -> [f,t];
var_args(l_element, 4) -> [t,t,t];
var_args(extract_next_element3, 6) -> [{x,7}];
var_args(l_is_eq_exact_literal, 4) -> [f,{x,3},t];
var_args(test_arity, 3) -> [f,y8,u8];
var_args(move_deallocate_return, 7) -> [t,{u,4}];
var_args(l_move_call_ext_only, 4) -> [e,{x,2}];
var_args(l_fadd, 0) -> [fr,fr,fr];
var_args(l_call_ext, 16) -> [{e,{dict,find,2}}];
var_args(l_call_ext, 15) -> [{e,{mnesia_lib,set,2}}];
var_args(try_end, 5) -> [{y,3}];
var_args(try_end, 4) -> [{y,5}];
var_args(l_move_call_ext, 20) -> [nil,e];
var_args(l_bs_match_string, 3) -> [x8,f,u8,str];
var_args(call_bif, 35) -> [{b,{erlang,get_stacktrace,0}}];
var_args(l_call_ext, 17) -> [{e,{lists,mapfoldl,3}}];
var_args(fmove_1, 0) -> [t,{fr,1}];
var_args(l_increment, 6) -> [x8,u32,u8,x8];
var_args(if_end, 0) -> [];
var_args(l_increment, 5) -> [{x,0},u8,u8,x8];
var_args(l_call_ext, 18) -> [{e,{dict,new,0}}];
var_args(is_integer, 4) -> [f,{x,4}];
var_args(l_bs_get_utf8, 0) -> [x8,f,x8];
var_args(is_list, 3) -> [f,{x,3}];
var_args(is_atom, 3) -> [f,{x,3}];
var_args(l_fetch, 13) -> [{x,4},t];
var_args(l_bs_init_bits_fail, 0) -> [u32,f,u8,t];
var_args(call_bif, 36) -> [{b,{ets,delete,2}}];
var_args(l_call_ext, 19) -> [{e,{test_server,lookup_config,2}}];
var_args(l_bs_test_zero_tail2, 4) -> [f,{x,4}];
var_args(fconv, 0) -> [t,{fr,0}];
var_args(case_end, 3) -> [{x,3}];
var_args(catch_end, 4) -> [{y,4}];
var_args(l_make_export, 0) -> [e];
var_args(l_rem, 1) -> [f,u8,{x,0}];
var_args(self, 2) -> [{x,2}];
var_args(fmove_2, 0) -> [fr,{x,0}];
var_args(l_bor, 1) -> [f,u8,x8];
var_args(l_call_ext_last, 4) -> [e,{u,4}];
var_args(call_bif, 37) -> [{b,{lists,keymember,3}}];
var_args(l_call_last, 9) -> [f,{u,9}];
var_args(bif1_body, 2) -> [{b,{erlang,hd,1}},{y,1},{x,2}];
var_args(is_binary, 2) -> [f,{x,2}];
var_args(l_fetch, 14) -> [{x,3},t];
var_args(l_call_ext, 20) -> [{e,{erl_syntax,type,1}}];
var_args(l_move_call_ext, 21) -> [t,{e,{test_server,seconds,1}}];
var_args(l_bs_skip_bits_all2, 0) -> [f,{x,2},{u8,8}];
var_args(l_catch, 7) -> [t,t];
var_args(l_move_call_ext, 22) -> [t,{e,{asn1ct_name,new,1}}];
var_args(extract_next_element, 15) -> [{x,11}];
var_args(badmatch, 4) -> [{y,2}];
var_args(l_move_call, 14) -> [{y,7},f];
var_args(self, 5) -> [t];
var_args(get_tuple_element, 8) -> [{x,0},u32,{x,0}];
var_args(l_move_call_ext, 23) -> [t,{e,{proplists,get_value,2}}];
var_args(l_move_call_ext, 24) -> [{y,7},e];
var_args(l_call_ext, 21) -> [{e,{erlang,binary_to_term,1}}];
var_args(l_move_call_only, 7) -> [f,nil];
var_args(put_list, 8) -> [{x,0},t,{y,0}];
var_args(l_is_eq_exact_immed, 22) -> [f,{y,5},t];
var_args(is_nonempty_list_test_heap, 0) -> [f,u8,u8];
var_args(is_tuple, 4) -> [f,{x,4}];
var_args(extract_next_element2, 9) -> [{x,12}];
var_args(case_end, 4) -> [{y,2}];
var_args(l_is_function2, 0) -> [f,{x,0},u8];
var_args(bif2_body, 3) -> [b,t];
var_args(fmove_2, 1) -> [fr,x8];
var_args(l_call_ext, 22) -> [{e,{dict,store,3}}];
var_args(extract_next_element, 16) -> [{y,5}];
var_args(extract_next_element2, 10) -> [{x,10}];
var_args(move_jump, 2) -> [f,nil];
var_args(move_return, 8) -> [{smallint,1}];
var_args(is_nonempty_list, 17) -> [f,{y,1}];
var_args(is_pid, 0) -> [f,{x,0}];
var_args(l_jump_on_val, 0) -> [x8,f,u8,u8];
var_args(l_get, 3) -> [t,{x,2}];
var_args(bif1_body, 3) -> [b,t,{x,0}];
var_args(l_select_val2, 11) -> [{x,6},f,t,f,t,f];
var_args(l_allocate_zero, 8) -> [{u,9}];
var_args(is_list, 4) -> [f,{x,4}];
var_args(l_is_ne_exact_immed, 4) -> [f,t,{a,true}];
var_args(fmove_1, 2) -> [t,fr];
var_args(bif1_body, 4) -> [b,y8,x8];
var_args(fmove_1, 1) -> [x8,fr];
var_args(is_nonempty_list, 18) -> [f,{x,15}];
var_args(l_bs_test_unit_8, 3) -> [f,t];
var_args(l_fetch, 15) -> [{x,5},t];
var_args(l_is_eq_exact_immed, 24) -> [f,{x,16},t];
var_args(put_list, 10) -> [t,t,{x,6}];
var_args(call_bif, 38) -> [{b,{erlang,now,0}}];
var_args(l_gc_bif1, 4) -> [f,{b,{erlang,length,1}},t,u8,y8];
var_args(extract_next_element, 17) -> [{y,4}];
var_args(is_atom, 6) -> [f,t];
var_args(l_move_call, 15) -> [{smallint,0},f];
var_args(l_allocate, 10) -> [u32];
var_args(l_move_call_ext_last, 3) -> [e,{u,2},t];
var_args(l_call_ext, 23) -> [{e,{prettypr,floating,1}}];
var_args(l_element, 1) -> [{x,0},x8,x8];
var_args(move_deallocate_return, 8) -> [t,{u,5}];
var_args(l_new_bs_put_integer, 0) -> [f,t,{u8,1},{u8,0},t];
var_args(l_call_ext, 24) -> [{e,{proplists,get_value,2}}];
var_args(l_move_call_last, 5) -> [f,{u,3},t];
var_args(l_move_call_ext, 25) -> [t,{e,{mnesia_lib,verbose,2}}];
var_args(init, 9) -> [{y,9}];
var_args(l_allocate, 8) -> [{u,8}];
var_args(l_call_ext, 25) -> [{e,{erlang,list_to_integer,1}}];
var_args(l_fdiv, 0) -> [fr,fr,fr];
var_args(bs_context_to_binary, 4) -> [t];
var_args(l_bif2, 6) -> [f,b,t];
var_args(l_call_ext_last, 6) -> [e,u32];
var_args(get_list, 8) -> [x8,y8,y8];
var_args(node, 4) -> [t];
var_args(l_call_ext, 26) -> [{e,{filename,join,1}}];
var_args(extract_next_element, 18) -> [{x,12}];
var_args(deallocate_return, 9) -> [{u,9}];
var_args(l_move_call_ext, 15) -> [{smallint,0},{e,{lists,seq,2}}];
var_args(is_binary, 3) -> [f,t];
var_args(move_deallocate_return, 9) -> [t,u32];
var_args(l_call_ext, 27) -> [{e,{lists,usort,1}}];
var_args(is_nonempty_list, 19) -> [f,{x,16}];
var_args(l_select_val_atoms, 2) -> [t,f,u32];
var_args(badmatch, 17) -> [t];
var_args(call_bif, 39) -> [{b,{erlang,spawn_link,1}}];
var_args(l_call_ext, 28) -> [{e,{proplists,get_value,3}}];
var_args(extract_next_element2, 11) -> [{x,11}];
var_args(badmatch, 5) -> [{y,3}];
var_args(case_end, 5) -> [{y,1}];
var_args(l_bs_restore2, 2) -> [{x,0},{u,1}];
var_args(l_fetch, 16) -> [t,{x,4}];
var_args(l_bs_get_integer, 0) -> [f,u8,u8,u8,x8];
var_args(l_is_eq_exact_immed, 25) -> [f,{x,15},t];
var_args(l_call_ext, 29) -> [{e,{sofs,to_external,1}}];
var_args(move_return, 9) -> [{smallint,0}];
var_args(is_function, 2) -> [f,t];
var_args(l_bif1, 2) -> [f,b,t,t];
var_args(l_move_call_ext, 26) -> [{x,4},e];
var_args(call_bif, 40) -> [{b,{ets,safe_fixtable,2}}];
var_args(l_call_ext, 30) -> [{e,{lists,filter,2}}];
var_args(case_end, 6) -> [{x,4}];
var_args(l_move_call_ext, 27) -> [t,{e,{io,format,1}}];
var_args(catch_end, 5) -> [{y,5}];
var_args(l_bs_get_binary_imm2, 0) -> [f,x8,u8,u8,{u8,0},x8];
var_args(l_move_call_ext, 28) -> [t,{e,{lists,duplicate,2}}];
var_args(call_bif, 42) -> [{b,{ets,next,2}}];
var_args(call_bif, 41) -> [{b,{erlang,fun_info,2}}];
var_args(l_call_ext, 32) -> [{e,{ordsets,from_list,1}}];
var_args(l_call_ext, 31) -> [{e,{string,tokens,2}}];
var_args(l_bs_test_unit_8, 1) -> [f,{x,3}];
var_args(l_move_call, 16) -> [{smallint,2},f];
var_args(l_bsr, 1) -> [f,u8,t];
var_args(l_move_call_ext, 29) -> [t,{e,{erlang,system_info,1}}];
var_args(l_bs_skip_bits_imm2, 0) -> [f,x8,u8];
var_args(l_move_call_ext, 30) -> [t,{e,{erlang,erase,1}}];
var_args(l_call_ext, 34) -> [{e,{asn1_db,dbget,2}}];
var_args(l_call_ext, 33) -> [{e,{prettypr,beside,2}}];
var_args(is_nil, 15) -> [f,{y,2}];
var_args(is_nil, 14) -> [f,{x,13}];
var_args(badmatch, 6) -> [{x,4}];
var_args(l_call_last, 11) -> [f,u32];
var_args(fconv, 1) -> [t,fr];
var_args(is_boolean, 0) -> [f,t];
var_args(l_is_ne_exact_immed, 5) -> [f,{x,4},t];
var_args(call_bif, 43) -> [{b,{erlang,monitor,2}}];
var_args(l_call_ext, 35) -> [{e,{lists,append,1}}];
var_args(is_nil, 16) -> [f,{x,15}];
var_args(l_move_call_only, 8) -> [f,{x,8}];
var_args(l_bs_test_unit_8, 2) -> [f,{x,1}];
var_args(catch_end, 7) -> [t];
var_args(l_bs_get_utf16, 1) -> [{x,0},f,u8,x8];
var_args(get_list, 9) -> [{x,0},y8,y8];
var_args(l_plus, 2) -> [f,u8,y8];
var_args(deallocate_return, 12) -> [u32];
var_args(l_element, 3) -> [x8,x8,x8];
var_args(move_jump, 3) -> [f,{x,4}];
var_args(l_bs_put_string, 0) -> [{u,1},str];
var_args(is_pid, 1) -> [f,t];
var_args(is_atom, 4) -> [f,{x,4}];
var_args(l_select_tuple_arity, 2) -> [{x,0},f,{u,8}];
var_args(l_call_ext, 36) -> [{e,{erlang,term_to_binary,1}}];
var_args(extract_next_element, 19) -> [{x,13}];
var_args(case_end, 7) -> [{y,3}];
var_args(l_catch, 6) -> [{y,6},t];
var_args(l_call_ext, 38) -> [{e,{lists,last,1}}];
var_args(l_call_ext, 37) -> [{e,{erlang,put,2}}];
var_args(move_jump, 4) -> [f,{y,2}];
var_args(is_nil, 17) -> [f,{x,14}];
var_args(is_list, 5) -> [f,{x,5}];
var_args(try_case_end, 0) -> [{x,0}];
var_args(l_bs_get_binary_all2, 1) -> [f,{x,0},u8,u8,x8];
var_args(move, 11) -> [t,{x,8}];
var_args(l_move_call_last, 6) -> [f,{u,5},t];
var_args(put_list, 14) -> [t,t,t];
var_args(move_jump, 5) -> [f,{y,1}];
var_args(move_return, 10) -> [{smallint,2}];
var_args(l_is_eq_exact_literal, 5) -> [f,{x,5},t];
var_args(bif2_body, 2) -> [b,{x,2}];
var_args(get_tuple_element, 9) -> [y8,u8,{x,0}];
var_args(put_list, 11) -> [x8,t,y8];
var_args(l_select_val2, 12) -> [{x,7},f,t,f,t,f];
var_args(call_bif, 44) -> [{b,{ets,match_object,2}}];
var_args(is_nonempty_list, 20) -> [f,{x,17}];
var_args(l_fsub, 0) -> [fr,fr,fr];
var_args(l_move_call_ext, 31) -> [t,{e,{lists,seq,2}}];
var_args(bif1_body, 5) -> [b,x8,x8];
var_args(l_call_ext, 39) -> [{e,{lists,delete,2}}];
var_args(extract_next_element3, 7) -> [{x,8}];
var_args(l_bs_start_match2, 3) -> [t,f,u8,u8,{x,0}];
var_args(l_trim, 8) -> [{u,9}];
var_args(bs_context_to_binary, 1) -> [{x,1}];
var_args(l_call_ext, 40) -> [{e,{lists,keydelete,3}}];
var_args(move_return, 11) -> [{a,undefined}];
var_args(l_call_fun, 4) -> [u8];
var_args(l_is_eq_exact_literal, 6) -> [f,{x,6},t];
var_args(l_is_ne_exact_immed, 6) -> [f,{y,0},t];
var_args(test_heap_1_put_list, 2) -> [u8,y8];
var_args(test_heap_1_put_list, 3) -> [u8,i8];
var_args(l_is_eq_exact_immed, 26) -> [f,{x,17},t];
var_args(self, 3) -> [{x,3}];
var_args(l_call_ext, 41) -> [{e,{unicode,characters_to_binary,1}}];
var_args(l_move_call_ext, 33) -> [t,{e,{mnesia_lib,dbg_out,2}}];
var_args(init, 10) -> [{y,10}];
var_args(l_bs_skip_bits_imm2, 1) -> [f,t,u32];
var_args(l_call_ext, 42) -> [{e,{erlang,max,2}}];
var_args(extract_next_element2, 12) -> [{x,13}];
var_args(badmatch, 7) -> [{y,4}];
var_args(l_move_call_ext_only, 5) -> [{e,{io,format,2}},t];
var_args(l_call_ext, 43) -> [{e,{file,read,2}}];
var_args(move_jump, 6) -> [f,{x,3}];
var_args(is_nil, 18) -> [f,{x,16}];
var_args(l_call_ext_only, 0) -> [{e,{gen_server,call,3}}];
var_args(l_fetch, 17) -> [t,{x,2}];
var_args(l_move_call_ext, 34) -> [t,{e,{erlang,binary_to_term,1}}];
var_args(l_move_call_ext, 35) -> [t,{e,{test_server,lookup_config,2}}];
var_args(l_is_eq_exact_immed, 27) -> [f,t,{a,asn1_NOVALUE}];
var_args(l_bs_append, 1) -> [f,u8,u8,u8,{x,0}];
var_args(l_bif2, 5) -> [f,{b,{erlang,'==',2}},t];
var_args(l_bs_get_binary2, 1) -> [f,x8,u8,t,u8,{u8,0},x8];
var_args(l_bs_get_integer_small_imm, 1) -> [x8,u8,f,u8,x8];
var_args(l_call_ext, 47) -> [{e,{file,write,2}}];
var_args(l_call_ext, 46) -> [{e,{ordsets,subtract,2}}];
var_args(l_call_ext, 45) -> [{e,{gb_trees,lookup,2}}];
var_args(l_call_ext, 44) -> [{e,{lists,duplicate,2}}];
var_args(move_return, 12) -> [{x,5}];
var_args(l_bs_save2, 1) -> [{x,0},{u,1}];
var_args(is_function, 0) -> [f,{x,0}];
var_args(l_bs_get_integer_imm, 0) -> [t,u8,u8,f,u8,x8];
var_args(l_move_call_ext_only, 6) -> [e,{x,1}];
var_args(l_call_ext, 48) -> [{e,{filename,basename,1}}];
var_args(l_move_call, 17) -> [{a,foo},f];
var_args(l_is_ne_exact_immed, 7) -> [f,x8,i8];
var_args(l_call_ext, 50) -> [{e,{file,read_file,1}}];
var_args(l_call_ext, 49) -> [{e,{gb_trees,empty,0}}];
var_args(is_integer, 5) -> [f,{x,5}];
var_args(move_return, 13) -> [{a,error}];
var_args(l_bs_put_string, 1) -> [{u,4},str];
var_args(try_end, 7) -> [t];
var_args(l_yield, 0) -> [];
var_args(l_move_call, 18) -> [{x,6},f];
var_args(l_fetch, 18) -> [{y,0},t];
var_args(l_is_eq_exact_immed, 28) -> [f,{x,18},t];
var_args(l_new_bs_put_integer, 1) -> [f,t,u8,u8,t];
var_args(node, 2) -> [{x,2}];
var_args(l_call_ext, 51) -> [{e,{file,read_file_info,1}}];
var_args(move_jump, 7) -> [f,{y,0}];
var_args(case_end, 9) -> [{y,4}];
var_args(case_end, 8) -> [{y,0}];
var_args(is_nonempty_list, 22) -> [f,{y,4}];
var_args(is_nonempty_list, 21) -> [f,{x,18}];
var_args(l_move_call, 19) -> [{y,12},f];
var_args(l_move_call_ext, 37) -> [t,{e,{io,fwrite,2}}];
var_args(get_list, 11) -> [t,t,{x,0}];
var_args(l_fetch, 19) -> [t,{x,3}];
var_args(l_new_bs_put_float_imm, 1) -> [f,u32,u8,t];
var_args(l_move_call, 20) -> [{a,endDocument},f];
var_args(l_call_ext_only, 1) -> [{e,{ssh_bits,encode,2}}];
var_args(l_gc_bif1, 6) -> [f,b,t,u8,t];
var_args(l_bif1, 1) -> [f,{b,{erlang,tuple_size,1}},{x,0},t];
var_args(l_move_call, 21) -> [{smallint,3},f];
var_args(l_is_ne_exact_literal, 0) -> [f,t,t];
var_args(l_bs_put_string, 2) -> [u32,str];
var_args(l_call_ext, 52) -> [{e,{io,format,3}}];
var_args(l_is_eq_exact_immed, 23) -> [f,{y,10},{a,ber}];
var_args(extract_next_element, 20) -> [{x,14}];
var_args(is_nil, 19) -> [f,{y,3}];
var_args(badmatch, 8) -> [{x,5}];
var_args(catch_end, 6) -> [{y,6}];
var_args(l_is_function2, 1) -> [f,x8,u8];
var_args(l_call_ext, 53) -> [{e,{filename,dirname,1}}];
var_args(move_return, 14) -> [{smallint,3}];
var_args(badmatch, 9) -> [{y,0}];
var_args(self, 4) -> [{y,0}];
var_args(l_call_ext, 56) -> [{e,{file,position,2}}];
var_args(l_call_ext, 55) -> [{e,{os,type,0}}];
var_args(l_call_ext, 54) -> [{e,{cerl,get_ann,1}}];
var_args(l_call_ext_last, 5) -> [e,{u,5}];
var_args(l_move_call, 23) -> [{a,ets},f];
var_args(l_move_call, 22) -> [{a,schema},f];
var_args(l_select_tuple_arity, 3) -> [{x,0},f,{u,10}];
var_args(l_apply, 0) -> [];
var_args(init, 16) -> [t];
var_args(init, 11) -> [{y,11}];
var_args(l_move_call_last, 8) -> [f,u32,t];
var_args(l_move_call_last, 7) -> [f,{u,4},t];
var_args(l_call_ext, 59) -> [{e,{file,make_dir,1}}];
var_args(l_call_ext, 58) -> [{e,{erl_syntax,atom,1}}];
var_args(l_call_ext, 57) -> [{e,{ssh_channel,cache_lookup,2}}];
var_args(extract_next_element2, 13) -> [{x,14}];
var_args(l_new_bs_put_integer_imm, 1) -> [f,u32,{u8,0},{smallint,0}];
var_args(try_end, 6) -> [{y,6}];
var_args(deallocate_return, 10) -> [{u,10}];
var_args(l_move_call, 24) -> [{y,8},f];
var_args(l_fetch, 20) -> [t,{x,5}];
var_args(get_list, 10) -> [x8,y8,x8];
var_args(l_allocate, 9) -> [{u,9}];
var_args(bs_init_writable, 0) -> [];
var_args(l_call_ext, 60) -> [{e,{orddict,find,2}}];
var_args(extract_next_element, 21) -> [{x,16}];
var_args(extract_next_element3, 8) -> [{x,11}];
var_args(is_integer, 6) -> [f,{x,6}];
var_args(move_jump, 8) -> [f,{y,3}];
var_args(badmatch, 10) -> [{x,7}];
var_args(is_nonempty_list, 23) -> [f,{x,20}];
var_args(l_bs_private_append, 0) -> [f,u8,t];
var_args(deallocate_return, 11) -> [{u,11}];
var_args(l_move_call, 25) -> [{a,false},f];
var_args(l_call_ext, 63) -> [{e,{asn1ct_gen,mk_var,1}}];
var_args(l_call_ext, 62) -> [{e,{sofs,family_union,2}}];
var_args(l_call_ext, 61) -> [{e,{mnesia_lib,exists,1}}];
var_args(move_jump, 9) -> [f,{a,true}];
var_args(move_return, 16) -> [{a,none}];
var_args(move_return, 15) -> [{a,no}];
var_args(bs_context_to_binary, 2) -> [{x,2}];
var_args(l_jump_on_val, 1) -> [{x,0},f,u8,u8];
var_args(l_increment, 7) -> [{x,0},u32,u8,y8];
var_args(l_is_ne_exact_immed, 8) -> [f,{y,2},t];
var_args(l_call_ext, 67) -> [{e,{file,rename,2}}];
var_args(l_call_ext, 66) -> [{e,{gb_trees,get,2}}];
var_args(l_call_ext, 65) -> [{e,{asn1ct_gen,get_inner,1}}];
var_args(l_call_ext, 64) -> [{e,{file,get_cwd,0}}];
var_args(extract_next_element2, 14) -> [{y,0}];
var_args(put_list, 13) -> [t,nil,t];
var_args(is_float, 0) -> [f,{x,0}];
var_args(l_is_eq_exact_immed, 29) -> [f,{x,19},t];
var_args(l_select_val2, 14) -> [{x,8},f,t,f,t,f];
var_args(l_call_ext, 69) -> [{e,{lists,dropwhile,2}}];
var_args(l_call_ext, 68) -> [{e,{lists,split,2}}];
var_args(extract_next_element3, 9) -> [{x,10}];
var_args(move_return, 17) -> [{smallint,4}];
var_args(is_nonempty_list, 25) -> [f,{y,0}];
var_args(is_nonempty_list, 24) -> [f,{x,19}];
var_args(l_select_tuple_arity2, 2) -> [y8,f,u8,f,u8,f];
var_args(is_atom, 5) -> [f,{x,5}];
var_args(l_call_ext_only, 2) -> [{e,{io,format,3}}];
var_args(l_is_ne_exact_immed, 9) -> [f,{y,1},t];
var_args(node, 3) -> [{x,3}];
var_args(is_tuple, 5) -> [f,{x,7}];
var_args(l_call_ext, 73) -> [{e,{mnesia_lib,cs_to_storage_type,2}}];
var_args(l_call_ext, 72) -> [{e,{lists,splitwith,2}}];
var_args(l_call_ext, 71) -> [{e,{test_server,fail,1}}];
var_args(l_call_ext, 70) -> [{e,{unicode,characters_to_list,1}}];
var_args(extract_next_element, 22) -> [{y,6}];
var_args(wait_timeout, 0) -> [f,t];
var_args(extract_next_element2, 15) -> [{x,16}];
var_args(is_nil, 20) -> [f,{x,17}];
var_args(is_nonempty_list, 26) -> [f,{y,6}];
var_args(l_wait_timeout, 2) -> [f,u32];
var_args(l_minus, 2) -> [f,u8,t];
var_args(is_tuple, 6) -> [f,{x,5}];
var_args(l_call_ext, 79) -> [{e,{sofs,relation,1}}];
var_args(l_call_ext, 78) -> [{e,{mnesia_monitor,use_dir,0}}];
var_args(l_call_ext, 77) -> [{e,{sets,is_element,2}}];
var_args(l_call_ext, 76) -> [{e,{lists,sublist,3}}];
var_args(l_call_ext, 75) -> [{e,{gb_trees,insert,3}}];
var_args(l_call_ext, 74) -> [{e,{random,uniform,1}}];
var_args(l_call_last, 10) -> [f,{u,10}];
var_args(l_bs_test_tail_imm2, 0) -> [f,t,u32];
var_args(move_jump, 10) -> [f,{a,false}];
var_args(move_return, 18) -> [{smallint,8}];
var_args(is_integer_allocate, 1) -> [f,t,u32];
var_args(is_nonempty_list, 27) -> [f,{y,9}];
var_args(l_new_bs_put_float_imm, 0) -> [f,{u,64},{u8,0},{x,0}];
var_args(l_fetch, 21) -> [t,{y,0}];
var_args(move, 12) -> [t,{x,10}];
var_args(move2, 9) -> [{x,0},x8,{x,0},x8];
var_args(l_bs_skip_bits_all2, 1) -> [f,{x,3},{u8,8}];
var_args(is_tuple, 7) -> [f,{y,4}];
var_args(l_call_ext, 84) -> [{e,{mnesia_schema,list2cs,1}}];
var_args(l_call_ext, 83) -> [{e,{gb_trees,from_orddict,1}}];
var_args(l_call_ext, 82) -> [{e,{gb_trees,to_list,1}}];
var_args(l_call_ext, 81) -> [{e,{gb_sets,empty,0}}];
var_args(l_call_ext, 80) -> [{e,{dict,fetch,2}}];
var_args(l_is_eq_exact_immed, 30) -> [f,{y,6},t];
var_args(is_nil, 21) -> [f,{y,0}];
var_args(recv_mark, 0) -> [f];
var_args(raise, 1) -> [t,t];
var_args(case_end, 10) -> [{x,5}];
var_args(is_function, 1) -> [f,{x,1}];
var_args(l_call_ext_only, 3) -> [{e,{asn1ct_gen,emit,1}}];
var_args(l_recv_set, 0) -> [];
var_args(l_bs_skip_bits_all2, 2) -> [f,t,u8];
var_args(l_fast_element, 3) -> [x8,u8,y8];
var_args(l_trim, 11) -> [u32];
var_args(l_times, 2) -> [f,u8,t];
var_args(bs_context_to_binary, 3) -> [{y,0}];
var_args(l_move_call_ext, 32) -> [{a,funky},{e,{estone_SUITE,req,2}}];
var_args(l_is_eq_exact_immed, 31) -> [f,{x,22},t];
var_args(is_port, 0) -> [f,t];
var_args(l_bs_get_float2, 0) -> [f,t,u8,t,u8,u8,t];
var_args(l_bs_get_utf8, 1) -> [t,f,t];
var_args(l_select_val2, 15) -> [{y,1},f,t,f,t,f];
var_args(l_select_tuple_arity, 4) -> [t,f,u32];
var_args(test_heap_1_put_list, 4) -> [u32,t];
var_args(is_map, 0) -> [f,t];
var_args(l_trim, 9) -> [{u,11}];
var_args(badmatch, 11) -> [{y,6}];
var_args(l_apply_fun, 0) -> [];
var_args(init, 12) -> [{y,12}];
var_args(l_is_eq_exact_immed, 32) -> [f,{y,7},t];
var_args(extract_next_element, 23) -> [{x,18}];
var_args(l_move_call_only, 10) -> [f,{x,9}];
var_args(l_move_call_only, 9) -> [f,{smallint,1}];
var_args(l_is_eq_exact_immed, 33) -> [f,{x,20},t];
var_args(l_is_ne_exact_immed, 10) -> [f,{x,5},t];
var_args(move_return, 19) -> [{a,nomatch}];
var_args(badmatch, 13) -> [{y,9}];
var_args(badmatch, 12) -> [{y,5}];
var_args(l_bs_get_integer_16, 0) -> [t,f,t];
var_args(l_bs_get_binary_all_reuse, 1) -> [{x,0},f,{u8,1}];
var_args(l_is_eq_exact_immed, 34) -> [f,{y,8},t];
var_args(move_jump, 11) -> [f,{a,asn1_NOVALUE}];
var_args(move_return, 21) -> [{smallint,16}];
var_args(move_return, 20) -> [{a,ignore}];
var_args(l_move_call_only, 11) -> [f,{x,10}];
var_args(badmatch, 14) -> [{y,1}];
var_args(is_list, 6) -> [f,{x,7}];
var_args(l_bs_init_fail, 1) -> [u32,f,u8,t];
var_args(l_move_call_ext, 36) -> [{a,auto_repair},{e,{mnesia_monitor,get_env,1}}];
var_args(is_tuple, 8) -> [f,{x,6}];
var_args(move_jump, 13) -> [f,{smallint,0}];
var_args(move_jump, 12) -> [f,{y,4}];
var_args(move_return, 22) -> [{x,6}];
var_args(is_nil, 22) -> [f,{x,19}];
var_args(is_nonempty_list, 29) -> [f,{y,7}];
var_args(is_nonempty_list, 28) -> [f,{y,5}];
var_args(l_bs_init, 0) -> [u32,u32,u8,t];
var_args(l_bs_restore2, 3) -> [t,u32];
var_args(move, 13) -> [t,{x,9}];
var_args(l_bs_get_binary_imm2, 1) -> [f,{x,0},u8,u32,u8,x8];
var_args(is_nonempty_list, 30) -> [f,{x,24}];
var_args(l_bs_init_bits, 0) -> [u32,u32,u8,t];
var_args(l_bs_put_utf16, 0) -> [f,u8,t];
var_args(is_bitstr, 0) -> [f,t];
var_args(l_bs_validate_unicode, 0) -> [f,t];
var_args(is_nonempty_list, 32) -> [f,{y,8}];
var_args(is_nonempty_list, 31) -> [f,{x,21}];
var_args(l_bs_save2, 2) -> [t,u32];
var_args(l_bs_utf16_size, 0) -> [t,t];
var_args(l_bs_get_binary2, 2) -> [f,t,u8,t,u8,u8,t];
var_args(l_is_eq_exact_immed, 35) -> [f,{x,23},t];
var_args(get_tuple_element, 10) -> [t,u32,t];
var_args(l_bs_get_integer_32, 2) -> [t,f,u8,t];
var_args(move_return, 24) -> [{smallint,5}];
var_args(move_return, 23) -> [{smallint,64}];
var_args(is_nil, 23) -> [f,{x,18}];
var_args(badmatch, 15) -> [{x,6}];
var_args(is_nonempty_list, 33) -> [f,{x,22}];
var_args(move, 14) -> [t,t];
var_args(l_bs_add, 1) -> [f,u8,t];
var_args(is_reference, 0) -> [f,t];
var_args(is_nil, 26) -> [f,{x,22}];
var_args(is_nil, 25) -> [f,{x,21}];
var_args(is_nil, 24) -> [f,{y,4}];
var_args(l_new_bs_put_binary, 0) -> [f,t,u8,u8,t];
var_args(badmatch, 16) -> [{y,8}];
var_args(is_nonempty_list, 34) -> [f,{x,25}];
var_args(init, 13) -> [{y,14}];
var_args(is_nil, 28) -> [f,{x,20}];
var_args(is_nil, 27) -> [f,{y,5}];
var_args(put_list, 12) -> [{x,0},{x,3},{x,8}];
var_args(is_nonempty_list, 35) -> [f,{x,26}];
var_args(l_bs_validate_unicode_retract, 0) -> [f];
var_args(l_wait_timeout, 0) -> [f,{u,1000}];
var_args(l_gc_bif2, 0) -> [f,b,u8,t];
var_args(init, 14) -> [{y,13}];
var_args(l_fast_element, 4) -> [t,u32,t];
var_args(l_trim, 10) -> [{u,10}];
var_args(l_new_bs_put_binary_all, 1) -> [f,t,u8];
var_args(l_apply_last, 0) -> [u32];
var_args(init, 15) -> [{y,16}];
var_args(is_number, 0) -> [f,t];
var_args(l_int_bnot, 0) -> [f,t,u8,t];
var_args(l_bs_put_utf8, 0) -> [f,t];
var_args(l_new_bs_put_float, 0) -> [f,t,u8,u8,t];
var_args(l_select_val2, 13) -> [{x,9},f,{a,atom},f,{a,var},f];
var_args(l_bs_utf8_size, 0) -> [t,t];
var_args(l_wait_timeout, 1) -> [f,{u,1}];
var_args(fmove_2, 2) -> [fr,t];
var_args(l_jump_on_val, 2) -> [t,f,u32,u32];
var_args(l_bs_get_binary_imm2, 2) -> [f,t,u8,u32,u8,t];
var_args(l_fnegate, 0) -> [fr,fr];
var_args(get_list, 12) -> [t,t,t];
var_args(l_bs_get_integer_imm, 1) -> [t,u32,u8,f,u8,t];
var_args(bif1_body, 6) -> [b,t,t];
var_args(l_bs_get_binary_all_reuse, 2) -> [t,f,u8];
var_args(l_bxor, 0) -> [f,u8,t];
var_args(l_new_bs_put_integer_imm, 2) -> [f,u32,u8,t];
var_args(l_int_div, 2) -> [f,u8,t];
var_args(l_gc_bif3, 0) -> [f,b,t,u8,t];
var_args(l_apply_only, 0) -> [];
var_args(l_bor, 2) -> [f,u8,t];
var_args(l_bs_start_match2, 4) -> [t,f,u8,u32,t];
var_args(l_rem, 2) -> [f,u8,t];
var_args(l_bsl, 2) -> [f,u8,t];
var_args(l_new_bs_put_binary_imm, 0) -> [f,u32,u8,t];
var_args(l_apply_fun_only, 0) -> [];
var_args(l_bs_get_integer_8, 2) -> [t,f,t];
var_args(l_bs_get_integer_small_imm, 2) -> [t,u32,f,u8,t];
var_args(l_hibernate, 0) -> [];
var_args(l_apply_fun_last, 0) -> [u32];
var_args(l_band, 2) -> [f,u8,t];
var_args(is_bigint, 0) -> [f,t];
var_args(on_load, 0) -> [];
var_args(move2, 10) -> [t,t,t,t];
var_args(l_bs_test_unit, 0) -> [f,t,u8];
var_args(l_m_div, 0) -> [f,u8,t];
var_args(l_select_val_smallints, 2) -> [t,f,u32];
var_args(is_function2, 0) -> [f,t,t];
var_args(test_heap, 1) -> [u32,u8];
var_args(func_info, 0) -> [t,t,u8];
var_args(call_bif, 0) -> [{b,{erlang,purge_module,1}}];
var_args(l_bs_get_utf16, 2) -> [t,f,u8,t];
var_args(l_put_tuple, 7) -> [t,u32];
var_args(allocate_init, 1) -> [u32,t];
var_args(l_call_fun_last, 1) -> [u8,u32];
var_args(set_tuple_element, 2) -> [t,t,u32];
var_args(allocate_heap, 1) -> [u32,u32,u8];
var_args(is_tuple_of_arity, 4) -> [f,t,u32];
var_args(test_arity, 4) -> [f,t,u32];
var_args(l_bs_match_string, 4) -> [t,f,u32,str];
var_args(is_nonempty_list_allocate, 2) -> [f,t,u32];
var_args(l_bs_append, 2) -> [f,u32,u8,u8,t];
var_args(try_case_end, 1) -> [t];
var_args(init3, 1) -> [t,t,t];
var_args(l_select_tuple_arity2, 3) -> [t,f,u32,f,u32,f];
var_args(init2, 1) -> [t,t];
var_args(l_is_function2, 2) -> [f,t,u8];
var_args(l_bs_get_binary_all2, 2) -> [f,t,u8,u8,t];
var_args(is_nonempty_list_test_heap, 1) -> [f,u32,u8];
var_args(allocate_heap_zero, 1) -> [u32,u32,u8];
var_args(l_bs_init_heap_bin, 1) -> [u32,u32,u8,t];
var_args(l_plus, 3) -> [f,u8,t];
var_args(l_bs_get_integer, 1) -> [f,u8,u8,u8,t];

var_args(Op, No) -> erlang:error({novar,Op,No}).

var_index(move, 0) -> 0;
var_index(move, 1) -> 1;
var_index(l_call, 0) -> 2;
var_index(test_heap, 0) -> 3;
var_index(move, 2) -> 4;
var_index(badmatch, 0) -> 5;
var_index(move, 3) -> 6;
var_index(l_put_tuple, 0) -> 7;
var_index(move, 4) -> 8;
var_index(move2, 1) -> 9;
var_index(get_tuple_element, 0) -> 10;
var_index(move2, 0) -> 11;
var_index(put_list, 0) -> 12;
var_index(is_tuple_of_arity, 1) -> 13;
var_index(get_tuple_element, 1) -> 14;
var_index(l_call_only, 0) -> 15;
var_index(call_bif, 7) -> 16;
var_index(l_bs_start_match2, 0) -> 17;
var_index(l_bs_test_zero_tail2, 0) -> 18;
var_index(l_bs_match_string, 0) -> 19;
var_index(l_is_eq_exact_immed, 0) -> 20;
var_index(put_list, 1) -> 21;
var_index(is_tuple_of_arity, 0) -> 22;
var_index(l_is_eq_exact_immed, 1) -> 23;
var_index(get_list, 0) -> 24;
var_index(l_put_tuple, 1) -> 25;
var_index(move, 5) -> 26;
var_index(l_call_ext, 85) -> 27;
var_index(l_move_call_ext, 0) -> 28;
var_index(return, 0) -> 29;
var_index(move2, 2) -> 30;
var_index(l_is_ge, 0) -> 31;
var_index(l_move_call_last, 0) -> 32;
var_index(l_make_fun, 0) -> 33;
var_index(is_tuple_of_arity, 2) -> 34;
var_index(extract_next_element2, 0) -> 35;
var_index(move_deallocate_return, 0) -> 36;
var_index(call_bif, 3) -> 37;
var_index(l_allocate, 0) -> 38;
var_index(l_fetch, 0) -> 39;
var_index(l_trim, 0) -> 40;
var_index(is_nil, 0) -> 41;
var_index(is_nonempty_list, 0) -> 42;
var_index(move_return, 25) -> 43;
var_index(l_move_call_ext, 1) -> 44;
var_index(deallocate_return, 0) -> 45;
var_index(case_end, 0) -> 46;
var_index(get_list, 1) -> 47;
var_index(l_allocate, 1) -> 48;
var_index(l_fetch, 1) -> 49;
var_index(jump, 0) -> 50;
var_index(extract_next_element, 0) -> 51;
var_index(put_list, 3) -> 52;
var_index(l_is_eq_exact_immed, 2) -> 53;
var_index(move2, 3) -> 54;
var_index(l_fetch, 2) -> 55;
var_index(l_is_eq_exact, 0) -> 56;
var_index(call_bif, 8) -> 57;
var_index(l_allocate, 2) -> 58;
var_index(l_is_eq_exact_immed, 3) -> 59;
var_index(get_tuple_element, 2) -> 60;
var_index(l_move_call, 26) -> 61;
var_index(deallocate_return, 1) -> 62;
var_index(move_return, 0) -> 63;
var_index(init2, 0) -> 64;
var_index(get_tuple_element, 3) -> 65;
var_index(put_list, 2) -> 66;
var_index(init, 0) -> 67;
var_index(move2, 4) -> 68;
var_index(l_is_eq_exact_immed, 4) -> 69;
var_index(call_bif, 9) -> 70;
var_index(l_fetch, 3) -> 71;
var_index(deallocate_return, 2) -> 72;
var_index(extract_next_element, 1) -> 73;
var_index(is_nonempty_list, 1) -> 74;
var_index(put_list, 4) -> 75;
var_index(l_put_tuple, 2) -> 76;
var_index(l_allocate, 3) -> 77;
var_index(is_tuple_of_arity, 3) -> 78;
var_index(move2, 5) -> 79;
var_index(init, 1) -> 80;
var_index(get_tuple_element, 4) -> 81;
var_index(l_fetch, 4) -> 82;
var_index(init3, 0) -> 83;
var_index(get_list, 2) -> 84;
var_index(l_move_call_ext, 38) -> 85;
var_index(allocate_init, 0) -> 86;
var_index(l_is_eq_exact_immed, 5) -> 87;
var_index(l_trim, 1) -> 88;
var_index(test_heap_1_put_list, 0) -> 89;
var_index(l_is_lt, 0) -> 90;
var_index(l_is_eq_exact_literal, 0) -> 91;
var_index(call_bif, 6) -> 92;
var_index(call_bif, 45) -> 93;
var_index(l_allocate_zero, 0) -> 94;
var_index(allocate_heap, 0) -> 95;
var_index(is_tuple, 0) -> 96;
var_index(move_return, 1) -> 97;
var_index(is_nonempty_list, 2) -> 98;
var_index(l_allocate_zero, 1) -> 99;
var_index(move, 6) -> 100;
var_index(l_call_last, 0) -> 101;
var_index(init, 2) -> 102;
var_index(l_gc_bif1, 0) -> 103;
var_index(deallocate_return, 3) -> 104;
var_index(get_tuple_element, 5) -> 105;
var_index(l_increment, 0) -> 106;
var_index(call_bif, 2) -> 107;
var_index(is_nonempty_list_allocate, 0) -> 108;
var_index(l_select_val_atoms, 0) -> 109;
var_index(l_move_call, 0) -> 110;
var_index(l_is_eq_exact_immed, 6) -> 111;
var_index(call_bif, 5) -> 112;
var_index(move_deallocate_return, 1) -> 113;
var_index(is_nonempty_list, 3) -> 114;
var_index(extract_next_element, 2) -> 115;
var_index(is_list, 0) -> 116;
var_index(l_select_val2, 3) -> 117;
var_index(l_fetch, 5) -> 118;
var_index(extract_next_element3, 0) -> 119;
var_index(is_nil, 1) -> 120;
var_index(move_deallocate_return, 2) -> 121;
var_index(l_call_last, 1) -> 122;
var_index(l_trim, 2) -> 123;
var_index(l_call_last, 2) -> 124;
var_index(get_list, 3) -> 125;
var_index(l_select_val2, 0) -> 126;
var_index(l_move_call_only, 12) -> 127;
var_index(is_nil, 2) -> 128;
var_index(move2, 6) -> 129;
var_index(l_allocate, 4) -> 130;
var_index(l_move_call_only, 0) -> 131;
var_index(extract_next_element2, 1) -> 132;
var_index(move_return, 2) -> 133;
var_index(test_arity, 0) -> 134;
var_index(move2, 7) -> 135;
var_index(l_call_ext, 0) -> 136;
var_index(l_new_bs_put_integer_imm, 0) -> 137;
var_index(l_select_val2, 4) -> 138;
var_index(l_move_call_only, 1) -> 139;
var_index(l_select_val2, 1) -> 140;
var_index(remove_message, 0) -> 141;
var_index(init, 3) -> 142;
var_index(l_allocate_zero, 2) -> 143;
var_index(l_plus, 0) -> 144;
var_index(l_catch, 0) -> 145;
var_index(deallocate_return, 4) -> 146;
var_index(is_nonempty_list, 4) -> 147;
var_index(bif1_body, 0) -> 148;
var_index(l_put_tuple, 3) -> 149;
var_index(extract_next_element, 3) -> 150;
var_index(l_is_eq_exact_immed, 7) -> 151;
var_index(move_jump, 14) -> 152;
var_index(move, 7) -> 153;
var_index(l_allocate_zero, 3) -> 154;
var_index(l_move_call_only, 2) -> 155;
var_index(l_select_tuple_arity2, 0) -> 156;
var_index(l_bs_start_match2, 1) -> 157;
var_index(catch_end, 0) -> 158;
var_index(move_return, 3) -> 159;
var_index(is_nonempty_list, 5) -> 160;
var_index(l_is_eq_exact_immed, 8) -> 161;
var_index(l_call_last, 3) -> 162;
var_index(l_move_call_only, 3) -> 163;
var_index(l_call_last, 4) -> 164;
var_index(get_list, 4) -> 165;
var_index(move_return, 4) -> 166;
var_index(move, 8) -> 167;
var_index(test_arity, 1) -> 168;
var_index(move_return, 5) -> 169;
var_index(is_nonempty_list, 6) -> 170;
var_index(l_call_fun, 0) -> 171;
var_index(l_increment, 1) -> 172;
var_index(put_list, 5) -> 173;
var_index(init, 4) -> 174;
var_index(l_is_eq, 0) -> 175;
var_index(l_select_val2, 2) -> 176;
var_index(l_move_call_ext, 2) -> 177;
var_index(l_call_ext_only, 4) -> 178;
var_index(l_bs_get_binary_all_reuse, 0) -> 179;
var_index(send, 0) -> 180;
var_index(set_tuple_element, 0) -> 181;
var_index(bif2_body, 0) -> 182;
var_index(extract_next_element2, 2) -> 183;
var_index(l_move_call, 1) -> 184;
var_index(l_catch, 1) -> 185;
var_index(is_nil, 3) -> 186;
var_index(move_deallocate_return, 3) -> 187;
var_index(call_bif, 10) -> 188;
var_index(extract_next_element2, 3) -> 189;
var_index(badmatch, 1) -> 190;
var_index(is_nonempty_list, 7) -> 191;
var_index(l_increment, 2) -> 192;
var_index(l_is_eq_exact_immed, 9) -> 193;
var_index(case_end, 1) -> 194;
var_index(extract_next_element, 4) -> 195;
var_index(l_trim, 3) -> 196;
var_index(l_move_call_ext_last, 0) -> 197;
var_index(is_nonempty_list, 8) -> 198;
var_index(l_move_call_last, 1) -> 199;
var_index(badmatch, 2) -> 200;
var_index(deallocate_return, 5) -> 201;
var_index(l_fetch, 6) -> 202;
var_index(l_select_val_atoms, 1) -> 203;
var_index(l_bs_add, 0) -> 204;
var_index(l_allocate, 5) -> 205;
var_index(l_select_val_smallints, 0) -> 206;
var_index(l_move_call, 2) -> 207;
var_index(l_select_tuple_arity2, 1) -> 208;
var_index(is_nonempty_list, 9) -> 209;
var_index(l_bs_test_zero_tail2, 1) -> 210;
var_index(l_loop_rec, 0) -> 211;
var_index(l_move_call_ext, 3) -> 212;
var_index(is_nil, 4) -> 213;
var_index(l_is_ne_exact_immed, 0) -> 214;
var_index(l_increment, 3) -> 215;
var_index(l_is_ne, 0) -> 216;
var_index(l_move_call, 3) -> 217;
var_index(l_plus, 1) -> 218;
var_index(catch_end, 1) -> 219;
var_index(l_move_call, 4) -> 220;
var_index(init, 5) -> 221;
var_index(l_call_last, 6) -> 222;
var_index(l_call_last, 5) -> 223;
var_index(l_minus, 0) -> 224;
var_index(l_move_call_ext, 4) -> 225;
var_index(l_bs_match_string, 1) -> 226;
var_index(l_allocate_zero, 4) -> 227;
var_index(extract_next_element, 5) -> 228;
var_index(l_select_val2, 6) -> 229;
var_index(l_bs_init_heap_bin, 0) -> 230;
var_index(l_allocate_zero, 5) -> 231;
var_index(l_bs_start_match2, 2) -> 232;
var_index(l_fetch, 7) -> 233;
var_index(l_call_ext_last, 0) -> 234;
var_index(is_nonempty_list_allocate, 1) -> 235;
var_index(l_bs_restore2, 0) -> 236;
var_index(loop_rec_end, 0) -> 237;
var_index(call_bif, 11) -> 238;
var_index(l_bs_get_utf16, 0) -> 239;
var_index(l_fast_element, 1) -> 240;
var_index(l_gc_bif1, 1) -> 241;
var_index(l_trim, 4) -> 242;
var_index(move, 9) -> 243;
var_index(wait, 0) -> 244;
var_index(l_is_eq_exact_immed, 10) -> 245;
var_index(extract_next_element2, 4) -> 246;
var_index(is_atom, 0) -> 247;
var_index(call_bif, 12) -> 248;
var_index(int_code_end, 0) -> 249;
var_index(l_call_fun_last, 0) -> 250;
var_index(l_move_call_ext_only, 0) -> 251;
var_index(get_tuple_element, 6) -> 252;
var_index(move_deallocate_return, 4) -> 253;
var_index(bs_context_to_binary, 0) -> 254;
var_index(init, 6) -> 255;
var_index(l_move_call_ext, 5) -> 256;
var_index(extract_next_element, 6) -> 257;
var_index(self, 0) -> 258;
var_index(is_nil, 5) -> 259;
var_index(l_move_call_ext, 6) -> 260;
var_index(l_call_ext_last, 1) -> 261;
var_index(l_call_fun, 1) -> 262;
var_index(l_is_eq_exact_immed, 11) -> 263;
var_index(l_move_call, 5) -> 264;
var_index(l_is_ne_exact_immed, 1) -> 265;
var_index(is_tuple, 1) -> 266;
var_index(extract_next_element, 7) -> 267;
var_index(l_move_call_last, 2) -> 268;
var_index(l_times, 0) -> 269;
var_index(l_bs_test_unit_8, 0) -> 270;
var_index(l_allocate, 6) -> 271;
var_index(badmatch, 3) -> 272;
var_index(l_move_call_ext_only, 1) -> 273;
var_index(l_bs_test_zero_tail2, 2) -> 274;
var_index(l_move_call_ext, 7) -> 275;
var_index(l_move_call_ext, 8) -> 276;
var_index(move_return, 6) -> 277;
var_index(l_put_tuple, 4) -> 278;
var_index(call_bif, 13) -> 279;
var_index(l_catch, 2) -> 280;
var_index(bif1_body, 1) -> 281;
var_index(l_select_val_smallints, 1) -> 282;
var_index(raise, 0) -> 283;
var_index(call_bif, 14) -> 284;
var_index(is_nil, 6) -> 285;
var_index(l_move_call, 6) -> 286;
var_index(l_move_call_ext, 9) -> 287;
var_index(l_select_val2, 7) -> 288;
var_index(is_integer, 0) -> 289;
var_index(extract_next_element3, 1) -> 290;
var_index(l_minus, 1) -> 291;
var_index(is_nonempty_list, 10) -> 292;
var_index(call_bif, 15) -> 293;
var_index(l_bs_save2, 0) -> 294;
var_index(l_call_ext_last, 2) -> 295;
var_index(extract_next_element, 8) -> 296;
var_index(l_call_ext, 1) -> 297;
var_index(l_new_bs_put_binary_all, 0) -> 298;
var_index(l_move_call_ext_only, 7) -> 299;
var_index(is_nil, 7) -> 300;
var_index(deallocate_return, 6) -> 301;
var_index(l_move_call_only, 4) -> 302;
var_index(self, 1) -> 303;
var_index(l_call_ext, 2) -> 304;
var_index(l_select_val2, 5) -> 305;
var_index(case_end, 2) -> 306;
var_index(allocate_heap_zero, 0) -> 307;
var_index(call_bif, 16) -> 308;
var_index(is_nonempty_list, 11) -> 309;
var_index(extract_next_element2, 5) -> 310;
var_index(apply, 0) -> 311;
var_index(try_end, 0) -> 312;
var_index(l_move_call, 7) -> 313;
var_index(call_bif, 17) -> 314;
var_index(l_fast_element, 0) -> 315;
var_index(test_heap_1_put_list, 1) -> 316;
var_index(call_bif, 19) -> 317;
var_index(call_bif, 18) -> 318;
var_index(call_bif, 20) -> 319;
var_index(l_bs_test_zero_tail2, 3) -> 320;
var_index(l_move_call_ext, 10) -> 321;
var_index(is_nil, 8) -> 322;
var_index(get_tuple_element, 7) -> 323;
var_index(call_bif, 21) -> 324;
var_index(l_call_ext, 3) -> 325;
var_index(catch_end, 2) -> 326;
var_index(l_put_tuple, 5) -> 327;
var_index(is_list, 1) -> 328;
var_index(extract_next_element3, 2) -> 329;
var_index(get_list, 7) -> 330;
var_index(l_bif2, 0) -> 331;
var_index(call_bif, 22) -> 332;
var_index(init, 7) -> 333;
var_index(try_end, 1) -> 334;
var_index(l_bs_get_integer_32, 0) -> 335;
var_index(test_arity, 2) -> 336;
var_index(l_trim, 5) -> 337;
var_index(l_increment, 4) -> 338;
var_index(l_move_call, 8) -> 339;
var_index(l_call_ext, 4) -> 340;
var_index(extract_next_element, 9) -> 341;
var_index(l_move_call_ext, 11) -> 342;
var_index(l_is_ne_exact, 0) -> 343;
var_index(l_bs_get_binary2, 0) -> 344;
var_index(extract_next_element, 24) -> 345;
var_index(is_integer, 1) -> 346;
var_index(l_band, 0) -> 347;
var_index(move_jump, 0) -> 348;
var_index(l_is_eq_exact_immed, 12) -> 349;
var_index(l_call_fun, 2) -> 350;
var_index(move_deallocate_return, 5) -> 351;
var_index(l_times, 1) -> 352;
var_index(l_move_call_last, 3) -> 353;
var_index(put_list, 7) -> 354;
var_index(l_call_last, 7) -> 355;
var_index(l_move_call_ext_only, 3) -> 356;
var_index(l_fast_element, 2) -> 357;
var_index(l_is_eq_exact_literal, 7) -> 358;
var_index(extract_next_element, 10) -> 359;
var_index(extract_next_element2, 6) -> 360;
var_index(is_tuple, 2) -> 361;
var_index(l_catch, 3) -> 362;
var_index(l_call_ext, 5) -> 363;
var_index(l_call_ext, 6) -> 364;
var_index(l_bif2, 1) -> 365;
var_index(l_is_eq_exact_immed, 13) -> 366;
var_index(is_binary, 0) -> 367;
var_index(l_call_ext, 7) -> 368;
var_index(extract_next_element2, 7) -> 369;
var_index(l_allocate_zero, 6) -> 370;
var_index(l_bsr, 0) -> 371;
var_index(l_fetch, 22) -> 372;
var_index(move, 10) -> 373;
var_index(extract_next_element3, 3) -> 374;
var_index(l_is_eq_exact_immed, 14) -> 375;
var_index(get_list, 5) -> 376;
var_index(is_atom, 1) -> 377;
var_index(extract_next_element3, 4) -> 378;
var_index(l_bs_get_binary_all2, 0) -> 379;
var_index(call_bif, 23) -> 380;
var_index(l_move_call_only, 5) -> 381;
var_index(call_bif, 24) -> 382;
var_index(is_nonempty_list, 12) -> 383;
var_index(l_is_eq_exact_immed, 15) -> 384;
var_index(l_fetch, 8) -> 385;
var_index(l_is_eq_exact_literal, 1) -> 386;
var_index(l_move_call_ext, 12) -> 387;
var_index(l_bs_get_integer_8, 0) -> 388;
var_index(l_is_ne_exact_immed, 2) -> 389;
var_index(put_list, 6) -> 390;
var_index(is_nil, 9) -> 391;
var_index(l_bsl, 0) -> 392;
var_index(l_select_val2, 9) -> 393;
var_index(is_list, 2) -> 394;
var_index(l_allocate_zero, 9) -> 395;
var_index(l_put_tuple, 6) -> 396;
var_index(l_call_ext, 8) -> 397;
var_index(l_bs_init_fail, 0) -> 398;
var_index(get_list, 6) -> 399;
var_index(l_bif2, 2) -> 400;
var_index(deallocate_return, 7) -> 401;
var_index(l_bs_get_integer_8, 1) -> 402;
var_index(set_tuple_element, 1) -> 403;
var_index(l_move_call_ext, 13) -> 404;
var_index(l_select_val2, 16) -> 405;
var_index(call_bif, 26) -> 406;
var_index(call_bif, 25) -> 407;
var_index(l_call_ext, 9) -> 408;
var_index(l_move_call, 9) -> 409;
var_index(l_is_eq_exact_literal, 2) -> 410;
var_index(l_bs_get_integer_32, 1) -> 411;
var_index(extract_next_element, 11) -> 412;
var_index(l_is_eq_exact_literal, 3) -> 413;
var_index(l_is_eq_exact_immed, 16) -> 414;
var_index(l_fetch, 9) -> 415;
var_index(l_bif2, 3) -> 416;
var_index(is_nil, 10) -> 417;
var_index(l_bsl, 1) -> 418;
var_index(l_bs_test_zero_tail2, 5) -> 419;
var_index(l_trim, 6) -> 420;
var_index(l_rem, 0) -> 421;
var_index(move2, 8) -> 422;
var_index(l_move_call_ext, 14) -> 423;
var_index(timeout, 0) -> 424;
var_index(is_binary, 1) -> 425;
var_index(catch_end, 3) -> 426;
var_index(l_move_call_ext_last, 1) -> 427;
var_index(l_call_last, 8) -> 428;
var_index(l_allocate_zero, 7) -> 429;
var_index(l_select_val2, 10) -> 430;
var_index(l_fetch, 10) -> 431;
var_index(l_fmul, 0) -> 432;
var_index(l_bs_match_string, 2) -> 433;
var_index(call_bif, 27) -> 434;
var_index(extract_next_element3, 10) -> 435;
var_index(l_gc_bif1, 2) -> 436;
var_index(move_deallocate_return, 6) -> 437;
var_index(l_allocate, 7) -> 438;
var_index(l_move_call, 10) -> 439;
var_index(l_catch, 4) -> 440;
var_index(is_nonempty_list, 36) -> 441;
var_index(l_bs_get_integer_small_imm, 0) -> 442;
var_index(extract_next_element, 12) -> 443;
var_index(l_is_eq_exact_immed, 36) -> 444;
var_index(l_call_ext, 10) -> 445;
var_index(move_jump, 1) -> 446;
var_index(l_fcheckerror, 0) -> 447;
var_index(fclearerror, 0) -> 448;
var_index(move_return, 7) -> 449;
var_index(l_bs_append, 0) -> 450;
var_index(node, 0) -> 451;
var_index(l_move_call, 11) -> 452;
var_index(extract_next_element2, 16) -> 453;
var_index(l_move_call_last, 4) -> 454;
var_index(l_is_eq_exact_immed, 17) -> 455;
var_index(l_call_ext, 11) -> 456;
var_index(extract_next_element, 13) -> 457;
var_index(l_move_call_ext_only, 2) -> 458;
var_index(l_is_ne_exact_immed, 11) -> 459;
var_index(l_is_eq_exact_immed, 18) -> 460;
var_index(l_get, 1) -> 461;
var_index(l_element, 2) -> 462;
var_index(is_integer, 2) -> 463;
var_index(is_integer, 7) -> 464;
var_index(l_move_call_ext_last, 4) -> 465;
var_index(l_bif2, 4) -> 466;
var_index(l_move_call_ext, 16) -> 467;
var_index(l_call_fun, 3) -> 468;
var_index(l_move_call, 12) -> 469;
var_index(call_bif, 28) -> 470;
var_index(is_nonempty_list, 13) -> 471;
var_index(try_end, 2) -> 472;
var_index(is_nil, 11) -> 473;
var_index(l_select_tuple_arity, 1) -> 474;
var_index(is_tuple, 3) -> 475;
var_index(l_move_call_ext_last, 2) -> 476;
var_index(node, 1) -> 477;
var_index(is_nonempty_list, 14) -> 478;
var_index(l_bs_restore2, 1) -> 479;
var_index(l_move_call_ext, 17) -> 480;
var_index(l_band, 1) -> 481;
var_index(l_is_eq_exact_immed, 19) -> 482;
var_index(l_get, 4) -> 483;
var_index(call_bif, 29) -> 484;
var_index(call_bif, 1) -> 485;
var_index(l_fetch, 11) -> 486;
var_index(l_gc_bif1, 3) -> 487;
var_index(is_nil, 12) -> 488;
var_index(l_move_call_only, 6) -> 489;
var_index(l_move_call, 13) -> 490;
var_index(system_limit, 0) -> 491;
var_index(l_element, 0) -> 492;
var_index(l_select_tuple_arity, 0) -> 493;
var_index(bif2_body, 1) -> 494;
var_index(is_float, 1) -> 495;
var_index(extract_next_element2, 8) -> 496;
var_index(l_select_val2, 8) -> 497;
var_index(is_integer_allocate, 0) -> 498;
var_index(is_atom, 2) -> 499;
var_index(l_int_div, 0) -> 500;
var_index(l_get, 2) -> 501;
var_index(l_gc_bif1, 5) -> 502;
var_index(l_move_call_ext, 18) -> 503;
var_index(is_nil, 29) -> 504;
var_index(l_is_eq_exact_immed, 20) -> 505;
var_index(call_bif, 30) -> 506;
var_index(l_bor, 0) -> 507;
var_index(l_bif1, 0) -> 508;
var_index(l_catch, 5) -> 509;
var_index(l_get, 0) -> 510;
var_index(l_fetch, 12) -> 511;
var_index(l_call_ext, 13) -> 512;
var_index(l_call_ext, 12) -> 513;
var_index(is_tuple, 9) -> 514;
var_index(try_end, 3) -> 515;
var_index(init, 8) -> 516;
var_index(call_bif, 32) -> 517;
var_index(call_bif, 31) -> 518;
var_index(is_nil, 13) -> 519;
var_index(apply_last, 0) -> 520;
var_index(call_bif, 33) -> 521;
var_index(l_int_div, 1) -> 522;
var_index(call_bif, 34) -> 523;
var_index(extract_next_element, 14) -> 524;
var_index(put_list, 9) -> 525;
var_index(is_nonempty_list, 15) -> 526;
var_index(case_end, 11) -> 527;
var_index(l_bs_skip_bits2, 0) -> 528;
var_index(l_call_ext, 14) -> 529;
var_index(deallocate_return, 8) -> 530;
var_index(l_call_ext_last, 3) -> 531;
var_index(l_move_call_ext, 19) -> 532;
var_index(l_is_ne_exact_immed, 3) -> 533;
var_index(extract_next_element3, 5) -> 534;
var_index(is_integer, 3) -> 535;
var_index(l_trim, 7) -> 536;
var_index(l_is_eq_exact_immed, 21) -> 537;
var_index(l_increment, 8) -> 538;
var_index(call_bif, 4) -> 539;
var_index(is_nonempty_list, 16) -> 540;
var_index(is_list, 7) -> 541;
var_index(l_element, 4) -> 542;
var_index(extract_next_element3, 6) -> 543;
var_index(l_is_eq_exact_literal, 4) -> 544;
var_index(test_arity, 3) -> 545;
var_index(move_deallocate_return, 7) -> 546;
var_index(l_move_call_ext_only, 4) -> 547;
var_index(l_fadd, 0) -> 548;
var_index(l_call_ext, 16) -> 549;
var_index(l_call_ext, 15) -> 550;
var_index(try_end, 5) -> 551;
var_index(try_end, 4) -> 552;
var_index(l_move_call_ext, 20) -> 553;
var_index(l_bs_match_string, 3) -> 554;
var_index(call_bif, 35) -> 555;
var_index(l_call_ext, 17) -> 556;
var_index(fmove_1, 0) -> 557;
var_index(l_increment, 6) -> 558;
var_index(if_end, 0) -> 559;
var_index(l_increment, 5) -> 560;
var_index(l_call_ext, 18) -> 561;
var_index(is_integer, 4) -> 562;
var_index(l_bs_get_utf8, 0) -> 563;
var_index(is_list, 3) -> 564;
var_index(is_atom, 3) -> 565;
var_index(l_fetch, 13) -> 566;
var_index(l_bs_init_bits_fail, 0) -> 567;
var_index(call_bif, 36) -> 568;
var_index(l_call_ext, 19) -> 569;
var_index(l_bs_test_zero_tail2, 4) -> 570;
var_index(fconv, 0) -> 571;
var_index(case_end, 3) -> 572;
var_index(catch_end, 4) -> 573;
var_index(l_make_export, 0) -> 574;
var_index(l_rem, 1) -> 575;
var_index(self, 2) -> 576;
var_index(fmove_2, 0) -> 577;
var_index(l_bor, 1) -> 578;
var_index(l_call_ext_last, 4) -> 579;
var_index(call_bif, 37) -> 580;
var_index(l_call_last, 9) -> 581;
var_index(bif1_body, 2) -> 582;
var_index(is_binary, 2) -> 583;
var_index(l_fetch, 14) -> 584;
var_index(l_call_ext, 20) -> 585;
var_index(l_move_call_ext, 21) -> 586;
var_index(l_bs_skip_bits_all2, 0) -> 587;
var_index(l_catch, 7) -> 588;
var_index(l_move_call_ext, 22) -> 589;
var_index(extract_next_element, 15) -> 590;
var_index(badmatch, 4) -> 591;
var_index(l_move_call, 14) -> 592;
var_index(self, 5) -> 593;
var_index(get_tuple_element, 8) -> 594;
var_index(l_move_call_ext, 23) -> 595;
var_index(l_move_call_ext, 24) -> 596;
var_index(l_call_ext, 21) -> 597;
var_index(l_move_call_only, 7) -> 598;
var_index(put_list, 8) -> 599;
var_index(l_is_eq_exact_immed, 22) -> 600;
var_index(is_nonempty_list_test_heap, 0) -> 601;
var_index(is_tuple, 4) -> 602;
var_index(extract_next_element2, 9) -> 603;
var_index(case_end, 4) -> 604;
var_index(l_is_function2, 0) -> 605;
var_index(bif2_body, 3) -> 606;
var_index(fmove_2, 1) -> 607;
var_index(l_call_ext, 22) -> 608;
var_index(extract_next_element, 16) -> 609;
var_index(extract_next_element2, 10) -> 610;
var_index(move_jump, 2) -> 611;
var_index(move_return, 8) -> 612;
var_index(is_nonempty_list, 17) -> 613;
var_index(is_pid, 0) -> 614;
var_index(l_jump_on_val, 0) -> 615;
var_index(l_get, 3) -> 616;
var_index(bif1_body, 3) -> 617;
var_index(l_select_val2, 11) -> 618;
var_index(l_allocate_zero, 8) -> 619;
var_index(is_list, 4) -> 620;
var_index(l_is_ne_exact_immed, 4) -> 621;
var_index(fmove_1, 2) -> 622;
var_index(bif1_body, 4) -> 623;
var_index(fmove_1, 1) -> 624;
var_index(is_nonempty_list, 18) -> 625;
var_index(l_bs_test_unit_8, 3) -> 626;
var_index(l_fetch, 15) -> 627;
var_index(l_is_eq_exact_immed, 24) -> 628;
var_index(put_list, 10) -> 629;
var_index(call_bif, 38) -> 630;
var_index(l_gc_bif1, 4) -> 631;
var_index(extract_next_element, 17) -> 632;
var_index(is_atom, 6) -> 633;
var_index(l_move_call, 15) -> 634;
var_index(l_allocate, 10) -> 635;
var_index(l_move_call_ext_last, 3) -> 636;
var_index(l_call_ext, 23) -> 637;
var_index(l_element, 1) -> 638;
var_index(move_deallocate_return, 8) -> 639;
var_index(l_new_bs_put_integer, 0) -> 640;
var_index(l_call_ext, 24) -> 641;
var_index(l_move_call_last, 5) -> 642;
var_index(l_move_call_ext, 25) -> 643;
var_index(init, 9) -> 644;
var_index(l_allocate, 8) -> 645;
var_index(l_call_ext, 25) -> 646;
var_index(l_fdiv, 0) -> 647;
var_index(bs_context_to_binary, 4) -> 648;
var_index(l_bif2, 6) -> 649;
var_index(l_call_ext_last, 6) -> 650;
var_index(get_list, 8) -> 651;
var_index(node, 4) -> 652;
var_index(l_call_ext, 26) -> 653;
var_index(extract_next_element, 18) -> 654;
var_index(deallocate_return, 9) -> 655;
var_index(l_move_call_ext, 15) -> 656;
var_index(is_binary, 3) -> 657;
var_index(move_deallocate_return, 9) -> 658;
var_index(l_call_ext, 27) -> 659;
var_index(is_nonempty_list, 19) -> 660;
var_index(l_select_val_atoms, 2) -> 661;
var_index(badmatch, 17) -> 662;
var_index(call_bif, 39) -> 663;
var_index(l_call_ext, 28) -> 664;
var_index(extract_next_element2, 11) -> 665;
var_index(badmatch, 5) -> 666;
var_index(case_end, 5) -> 667;
var_index(l_bs_restore2, 2) -> 668;
var_index(l_fetch, 16) -> 669;
var_index(l_bs_get_integer, 0) -> 670;
var_index(l_is_eq_exact_immed, 25) -> 671;
var_index(l_call_ext, 29) -> 672;
var_index(move_return, 9) -> 673;
var_index(is_function, 2) -> 674;
var_index(l_bif1, 2) -> 675;
var_index(l_move_call_ext, 26) -> 676;
var_index(call_bif, 40) -> 677;
var_index(l_call_ext, 30) -> 678;
var_index(case_end, 6) -> 679;
var_index(l_move_call_ext, 27) -> 680;
var_index(catch_end, 5) -> 681;
var_index(l_bs_get_binary_imm2, 0) -> 682;
var_index(l_move_call_ext, 28) -> 683;
var_index(call_bif, 42) -> 684;
var_index(call_bif, 41) -> 685;
var_index(l_call_ext, 32) -> 686;
var_index(l_call_ext, 31) -> 687;
var_index(l_bs_test_unit_8, 1) -> 688;
var_index(l_move_call, 16) -> 689;
var_index(l_bsr, 1) -> 690;
var_index(l_move_call_ext, 29) -> 691;
var_index(l_bs_skip_bits_imm2, 0) -> 692;
var_index(l_move_call_ext, 30) -> 693;
var_index(l_call_ext, 34) -> 694;
var_index(l_call_ext, 33) -> 695;
var_index(is_nil, 15) -> 696;
var_index(is_nil, 14) -> 697;
var_index(badmatch, 6) -> 698;
var_index(l_call_last, 11) -> 699;
var_index(fconv, 1) -> 700;
var_index(is_boolean, 0) -> 701;
var_index(l_is_ne_exact_immed, 5) -> 702;
var_index(call_bif, 43) -> 703;
var_index(l_call_ext, 35) -> 704;
var_index(is_nil, 16) -> 705;
var_index(l_move_call_only, 8) -> 706;
var_index(l_bs_test_unit_8, 2) -> 707;
var_index(catch_end, 7) -> 708;
var_index(l_bs_get_utf16, 1) -> 709;
var_index(get_list, 9) -> 710;
var_index(l_plus, 2) -> 711;
var_index(deallocate_return, 12) -> 712;
var_index(l_element, 3) -> 713;
var_index(move_jump, 3) -> 714;
var_index(l_bs_put_string, 0) -> 715;
var_index(is_pid, 1) -> 716;
var_index(is_atom, 4) -> 717;
var_index(l_select_tuple_arity, 2) -> 718;
var_index(l_call_ext, 36) -> 719;
var_index(extract_next_element, 19) -> 720;
var_index(case_end, 7) -> 721;
var_index(l_catch, 6) -> 722;
var_index(l_call_ext, 38) -> 723;
var_index(l_call_ext, 37) -> 724;
var_index(move_jump, 4) -> 725;
var_index(is_nil, 17) -> 726;
var_index(is_list, 5) -> 727;
var_index(try_case_end, 0) -> 728;
var_index(l_bs_get_binary_all2, 1) -> 729;
var_index(move, 11) -> 730;
var_index(l_move_call_last, 6) -> 731;
var_index(put_list, 14) -> 732;
var_index(move_jump, 5) -> 733;
var_index(move_return, 10) -> 734;
var_index(l_is_eq_exact_literal, 5) -> 735;
var_index(bif2_body, 2) -> 736;
var_index(get_tuple_element, 9) -> 737;
var_index(put_list, 11) -> 738;
var_index(l_select_val2, 12) -> 739;
var_index(call_bif, 44) -> 740;
var_index(is_nonempty_list, 20) -> 741;
var_index(l_fsub, 0) -> 742;
var_index(l_move_call_ext, 31) -> 743;
var_index(bif1_body, 5) -> 744;
var_index(l_call_ext, 39) -> 745;
var_index(extract_next_element3, 7) -> 746;
var_index(l_bs_start_match2, 3) -> 747;
var_index(l_trim, 8) -> 748;
var_index(bs_context_to_binary, 1) -> 749;
var_index(l_call_ext, 40) -> 750;
var_index(move_return, 11) -> 751;
var_index(l_call_fun, 4) -> 752;
var_index(l_is_eq_exact_literal, 6) -> 753;
var_index(l_is_ne_exact_immed, 6) -> 754;
var_index(test_heap_1_put_list, 2) -> 755;
var_index(test_heap_1_put_list, 3) -> 756;
var_index(l_is_eq_exact_immed, 26) -> 757;
var_index(self, 3) -> 758;
var_index(l_call_ext, 41) -> 759;
var_index(l_move_call_ext, 33) -> 760;
var_index(init, 10) -> 761;
var_index(l_bs_skip_bits_imm2, 1) -> 762;
var_index(l_call_ext, 42) -> 763;
var_index(extract_next_element2, 12) -> 764;
var_index(badmatch, 7) -> 765;
var_index(l_move_call_ext_only, 5) -> 766;
var_index(l_call_ext, 43) -> 767;
var_index(move_jump, 6) -> 768;
var_index(is_nil, 18) -> 769;
var_index(l_call_ext_only, 0) -> 770;
var_index(l_fetch, 17) -> 771;
var_index(l_move_call_ext, 34) -> 772;
var_index(l_move_call_ext, 35) -> 773;
var_index(l_is_eq_exact_immed, 27) -> 774;
var_index(l_bs_append, 1) -> 775;
var_index(l_bif2, 5) -> 776;
var_index(l_bs_get_binary2, 1) -> 777;
var_index(l_bs_get_integer_small_imm, 1) -> 778;
var_index(l_call_ext, 47) -> 779;
var_index(l_call_ext, 46) -> 780;
var_index(l_call_ext, 45) -> 781;
var_index(l_call_ext, 44) -> 782;
var_index(move_return, 12) -> 783;
var_index(l_bs_save2, 1) -> 784;
var_index(is_function, 0) -> 785;
var_index(l_bs_get_integer_imm, 0) -> 786;
var_index(l_move_call_ext_only, 6) -> 787;
var_index(l_call_ext, 48) -> 788;
var_index(l_move_call, 17) -> 789;
var_index(l_is_ne_exact_immed, 7) -> 790;
var_index(l_call_ext, 50) -> 791;
var_index(l_call_ext, 49) -> 792;
var_index(is_integer, 5) -> 793;
var_index(move_return, 13) -> 794;
var_index(l_bs_put_string, 1) -> 795;
var_index(try_end, 7) -> 796;
var_index(l_yield, 0) -> 797;
var_index(l_move_call, 18) -> 798;
var_index(l_fetch, 18) -> 799;
var_index(l_is_eq_exact_immed, 28) -> 800;
var_index(l_new_bs_put_integer, 1) -> 801;
var_index(node, 2) -> 802;
var_index(l_call_ext, 51) -> 803;
var_index(move_jump, 7) -> 804;
var_index(case_end, 9) -> 805;
var_index(case_end, 8) -> 806;
var_index(is_nonempty_list, 22) -> 807;
var_index(is_nonempty_list, 21) -> 808;
var_index(l_move_call, 19) -> 809;
var_index(l_move_call_ext, 37) -> 810;
var_index(get_list, 11) -> 811;
var_index(l_fetch, 19) -> 812;
var_index(l_new_bs_put_float_imm, 1) -> 813;
var_index(l_move_call, 20) -> 814;
var_index(l_call_ext_only, 1) -> 815;
var_index(l_gc_bif1, 6) -> 816;
var_index(l_bif1, 1) -> 817;
var_index(l_move_call, 21) -> 818;
var_index(l_is_ne_exact_literal, 0) -> 819;
var_index(l_bs_put_string, 2) -> 820;
var_index(l_call_ext, 52) -> 821;
var_index(l_is_eq_exact_immed, 23) -> 822;
var_index(extract_next_element, 20) -> 823;
var_index(is_nil, 19) -> 824;
var_index(badmatch, 8) -> 825;
var_index(catch_end, 6) -> 826;
var_index(l_is_function2, 1) -> 827;
var_index(l_call_ext, 53) -> 828;
var_index(move_return, 14) -> 829;
var_index(badmatch, 9) -> 830;
var_index(self, 4) -> 831;
var_index(l_call_ext, 56) -> 832;
var_index(l_call_ext, 55) -> 833;
var_index(l_call_ext, 54) -> 834;
var_index(l_call_ext_last, 5) -> 835;
var_index(l_move_call, 23) -> 836;
var_index(l_move_call, 22) -> 837;
var_index(l_select_tuple_arity, 3) -> 838;
var_index(l_apply, 0) -> 839;
var_index(init, 16) -> 840;
var_index(init, 11) -> 841;
var_index(l_move_call_last, 8) -> 842;
var_index(l_move_call_last, 7) -> 843;
var_index(l_call_ext, 59) -> 844;
var_index(l_call_ext, 58) -> 845;
var_index(l_call_ext, 57) -> 846;
var_index(extract_next_element2, 13) -> 847;
var_index(l_new_bs_put_integer_imm, 1) -> 848;
var_index(try_end, 6) -> 849;
var_index(deallocate_return, 10) -> 850;
var_index(l_move_call, 24) -> 851;
var_index(l_fetch, 20) -> 852;
var_index(get_list, 10) -> 853;
var_index(l_allocate, 9) -> 854;
var_index(bs_init_writable, 0) -> 855;
var_index(l_call_ext, 60) -> 856;
var_index(extract_next_element, 21) -> 857;
var_index(extract_next_element3, 8) -> 858;
var_index(is_integer, 6) -> 859;
var_index(move_jump, 8) -> 860;
var_index(badmatch, 10) -> 861;
var_index(is_nonempty_list, 23) -> 862;
var_index(l_bs_private_append, 0) -> 863;
var_index(deallocate_return, 11) -> 864;
var_index(l_move_call, 25) -> 865;
var_index(l_call_ext, 63) -> 866;
var_index(l_call_ext, 62) -> 867;
var_index(l_call_ext, 61) -> 868;
var_index(move_jump, 9) -> 869;
var_index(move_return, 16) -> 870;
var_index(move_return, 15) -> 871;
var_index(bs_context_to_binary, 2) -> 872;
var_index(l_jump_on_val, 1) -> 873;
var_index(l_increment, 7) -> 874;
var_index(l_is_ne_exact_immed, 8) -> 875;
var_index(l_call_ext, 67) -> 876;
var_index(l_call_ext, 66) -> 877;
var_index(l_call_ext, 65) -> 878;
var_index(l_call_ext, 64) -> 879;
var_index(extract_next_element2, 14) -> 880;
var_index(put_list, 13) -> 881;
var_index(is_float, 0) -> 882;
var_index(l_is_eq_exact_immed, 29) -> 883;
var_index(l_select_val2, 14) -> 884;
var_index(l_call_ext, 69) -> 885;
var_index(l_call_ext, 68) -> 886;
var_index(extract_next_element3, 9) -> 887;
var_index(move_return, 17) -> 888;
var_index(is_nonempty_list, 25) -> 889;
var_index(is_nonempty_list, 24) -> 890;
var_index(l_select_tuple_arity2, 2) -> 891;
var_index(is_atom, 5) -> 892;
var_index(l_call_ext_only, 2) -> 893;
var_index(l_is_ne_exact_immed, 9) -> 894;
var_index(node, 3) -> 895;
var_index(is_tuple, 5) -> 896;
var_index(l_call_ext, 73) -> 897;
var_index(l_call_ext, 72) -> 898;
var_index(l_call_ext, 71) -> 899;
var_index(l_call_ext, 70) -> 900;
var_index(extract_next_element, 22) -> 901;
var_index(wait_timeout, 0) -> 902;
var_index(extract_next_element2, 15) -> 903;
var_index(is_nil, 20) -> 904;
var_index(is_nonempty_list, 26) -> 905;
var_index(l_wait_timeout, 2) -> 906;
var_index(l_minus, 2) -> 907;
var_index(is_tuple, 6) -> 908;
var_index(l_call_ext, 79) -> 909;
var_index(l_call_ext, 78) -> 910;
var_index(l_call_ext, 77) -> 911;
var_index(l_call_ext, 76) -> 912;
var_index(l_call_ext, 75) -> 913;
var_index(l_call_ext, 74) -> 914;
var_index(l_call_last, 10) -> 915;
var_index(l_bs_test_tail_imm2, 0) -> 916;
var_index(move_jump, 10) -> 917;
var_index(move_return, 18) -> 918;
var_index(is_integer_allocate, 1) -> 919;
var_index(is_nonempty_list, 27) -> 920;
var_index(l_new_bs_put_float_imm, 0) -> 921;
var_index(l_fetch, 21) -> 922;
var_index(move, 12) -> 923;
var_index(move2, 9) -> 924;
var_index(l_bs_skip_bits_all2, 1) -> 925;
var_index(is_tuple, 7) -> 926;
var_index(l_call_ext, 84) -> 927;
var_index(l_call_ext, 83) -> 928;
var_index(l_call_ext, 82) -> 929;
var_index(l_call_ext, 81) -> 930;
var_index(l_call_ext, 80) -> 931;
var_index(l_is_eq_exact_immed, 30) -> 932;
var_index(is_nil, 21) -> 933;
var_index(recv_mark, 0) -> 934;
var_index(raise, 1) -> 935;
var_index(case_end, 10) -> 936;
var_index(is_function, 1) -> 937;
var_index(l_call_ext_only, 3) -> 938;
var_index(l_recv_set, 0) -> 939;
var_index(l_bs_skip_bits_all2, 2) -> 940;
var_index(l_fast_element, 3) -> 941;
var_index(l_trim, 11) -> 942;
var_index(l_times, 2) -> 943;
var_index(bs_context_to_binary, 3) -> 944;
var_index(l_move_call_ext, 32) -> 945;
var_index(l_is_eq_exact_immed, 31) -> 946;
var_index(is_port, 0) -> 947;
var_index(l_bs_get_float2, 0) -> 948;
var_index(l_bs_get_utf8, 1) -> 949;
var_index(l_select_val2, 15) -> 950;
var_index(l_select_tuple_arity, 4) -> 951;
var_index(test_heap_1_put_list, 4) -> 952;
var_index(is_map, 0) -> 953;
var_index(l_trim, 9) -> 954;
var_index(badmatch, 11) -> 955;
var_index(l_apply_fun, 0) -> 956;
var_index(init, 12) -> 957;
var_index(l_is_eq_exact_immed, 32) -> 958;
var_index(extract_next_element, 23) -> 959;
var_index(l_move_call_only, 10) -> 960;
var_index(l_move_call_only, 9) -> 961;
var_index(l_is_eq_exact_immed, 33) -> 962;
var_index(l_is_ne_exact_immed, 10) -> 963;
var_index(move_return, 19) -> 964;
var_index(badmatch, 13) -> 965;
var_index(badmatch, 12) -> 966;
var_index(l_bs_get_integer_16, 0) -> 967;
var_index(l_bs_get_binary_all_reuse, 1) -> 968;
var_index(l_is_eq_exact_immed, 34) -> 969;
var_index(move_jump, 11) -> 970;
var_index(move_return, 21) -> 971;
var_index(move_return, 20) -> 972;
var_index(l_move_call_only, 11) -> 973;
var_index(badmatch, 14) -> 974;
var_index(is_list, 6) -> 975;
var_index(l_bs_init_fail, 1) -> 976;
var_index(l_move_call_ext, 36) -> 977;
var_index(is_tuple, 8) -> 978;
var_index(move_jump, 13) -> 979;
var_index(move_jump, 12) -> 980;
var_index(move_return, 22) -> 981;
var_index(is_nil, 22) -> 982;
var_index(is_nonempty_list, 29) -> 983;
var_index(is_nonempty_list, 28) -> 984;
var_index(l_bs_init, 0) -> 985;
var_index(l_bs_restore2, 3) -> 986;
var_index(move, 13) -> 987;
var_index(l_bs_get_binary_imm2, 1) -> 988;
var_index(is_nonempty_list, 30) -> 989;
var_index(l_bs_init_bits, 0) -> 990;
var_index(l_bs_put_utf16, 0) -> 991;
var_index(is_bitstr, 0) -> 992;
var_index(l_bs_validate_unicode, 0) -> 993;
var_index(is_nonempty_list, 32) -> 994;
var_index(is_nonempty_list, 31) -> 995;
var_index(l_bs_save2, 2) -> 996;
var_index(l_bs_utf16_size, 0) -> 997;
var_index(l_bs_get_binary2, 2) -> 998;
var_index(l_is_eq_exact_immed, 35) -> 999;
var_index(get_tuple_element, 10) -> 1000;
var_index(l_bs_get_integer_32, 2) -> 1001;
var_index(move_return, 24) -> 1002;
var_index(move_return, 23) -> 1003;
var_index(is_nil, 23) -> 1004;
var_index(badmatch, 15) -> 1005;
var_index(is_nonempty_list, 33) -> 1006;
var_index(move, 14) -> 1007;
var_index(l_bs_add, 1) -> 1008;
var_index(is_reference, 0) -> 1009;
var_index(is_nil, 26) -> 1010;
var_index(is_nil, 25) -> 1011;
var_index(is_nil, 24) -> 1012;
var_index(l_new_bs_put_binary, 0) -> 1013;
var_index(badmatch, 16) -> 1014;
var_index(is_nonempty_list, 34) -> 1015;
var_index(init, 13) -> 1016;
var_index(is_nil, 28) -> 1017;
var_index(is_nil, 27) -> 1018;
var_index(put_list, 12) -> 1019;
var_index(is_nonempty_list, 35) -> 1020;
var_index(l_bs_validate_unicode_retract, 0) -> 1021;
var_index(l_wait_timeout, 0) -> 1022;
var_index(l_gc_bif2, 0) -> 1023;
var_index(init, 14) -> 1024;
var_index(l_fast_element, 4) -> 1025;
var_index(l_trim, 10) -> 1026;
var_index(l_new_bs_put_binary_all, 1) -> 1027;
var_index(l_apply_last, 0) -> 1028;
var_index(init, 15) -> 1029;
var_index(is_number, 0) -> 1030;
var_index(l_int_bnot, 0) -> 1031;
var_index(l_bs_put_utf8, 0) -> 1032;
var_index(l_new_bs_put_float, 0) -> 1033;
var_index(l_select_val2, 13) -> 1034;
var_index(l_bs_utf8_size, 0) -> 1035;
var_index(l_wait_timeout, 1) -> 1036;
var_index(fmove_2, 2) -> 1037;
var_index(l_jump_on_val, 2) -> 1038;
var_index(l_bs_get_binary_imm2, 2) -> 1039;
var_index(l_fnegate, 0) -> 1040;
var_index(get_list, 12) -> 1041;
var_index(l_bs_get_integer_imm, 1) -> 1042;
var_index(bif1_body, 6) -> 1043;
var_index(l_bs_get_binary_all_reuse, 2) -> 1044;
var_index(l_bxor, 0) -> 1045;
var_index(l_new_bs_put_integer_imm, 2) -> 1046;
var_index(l_int_div, 2) -> 1047;
var_index(l_gc_bif3, 0) -> 1048;
var_index(l_apply_only, 0) -> 1049;
var_index(l_bor, 2) -> 1050;
var_index(l_bs_start_match2, 4) -> 1051;
var_index(l_rem, 2) -> 1052;
var_index(l_bsl, 2) -> 1053;
var_index(l_new_bs_put_binary_imm, 0) -> 1054;
var_index(l_apply_fun_only, 0) -> 1055;
var_index(l_bs_get_integer_8, 2) -> 1056;
var_index(l_bs_get_integer_small_imm, 2) -> 1057;
var_index(l_hibernate, 0) -> 1058;
var_index(l_apply_fun_last, 0) -> 1059;
var_index(l_band, 2) -> 1060;
var_index(is_bigint, 0) -> 1061;
var_index(on_load, 0) -> 1062;
var_index(move2, 10) -> 1063;
var_index(l_bs_test_unit, 0) -> 1064;
var_index(l_m_div, 0) -> 1065;
var_index(l_select_val_smallints, 2) -> 1066;
var_index(is_function2, 0) -> 1067;
var_index(test_heap, 1) -> 1068;
var_index(func_info, 0) -> 1069;
var_index(call_bif, 0) -> 1070;
var_index(l_bs_get_utf16, 2) -> 1071;
var_index(l_put_tuple, 7) -> 1072;
var_index(allocate_init, 1) -> 1073;
var_index(l_call_fun_last, 1) -> 1074;
var_index(set_tuple_element, 2) -> 1075;
var_index(allocate_heap, 1) -> 1076;
var_index(is_tuple_of_arity, 4) -> 1077;
var_index(test_arity, 4) -> 1078;
var_index(l_bs_match_string, 4) -> 1079;
var_index(is_nonempty_list_allocate, 2) -> 1080;
var_index(l_bs_append, 2) -> 1081;
var_index(try_case_end, 1) -> 1082;
var_index(init3, 1) -> 1083;
var_index(l_select_tuple_arity2, 3) -> 1084;
var_index(init2, 1) -> 1085;
var_index(l_is_function2, 2) -> 1086;
var_index(l_bs_get_binary_all2, 2) -> 1087;
var_index(is_nonempty_list_test_heap, 1) -> 1088;
var_index(allocate_heap_zero, 1) -> 1089;
var_index(l_bs_init_heap_bin, 1) -> 1090;
var_index(l_plus, 3) -> 1091;
var_index(l_bs_get_integer, 1) -> 1092;

var_index(Op, No) -> erlang:error({noindex,Op,No}).

var_by_index(0) -> {move, 0};
var_by_index(1) -> {move, 1};
var_by_index(2) -> {l_call, 0};
var_by_index(3) -> {test_heap, 0};
var_by_index(4) -> {move, 2};
var_by_index(5) -> {badmatch, 0};
var_by_index(6) -> {move, 3};
var_by_index(7) -> {l_put_tuple, 0};
var_by_index(8) -> {move, 4};
var_by_index(9) -> {move2, 1};
var_by_index(10) -> {get_tuple_element, 0};
var_by_index(11) -> {move2, 0};
var_by_index(12) -> {put_list, 0};
var_by_index(13) -> {is_tuple_of_arity, 1};
var_by_index(14) -> {get_tuple_element, 1};
var_by_index(15) -> {l_call_only, 0};
var_by_index(16) -> {call_bif, 7};
var_by_index(17) -> {l_bs_start_match2, 0};
var_by_index(18) -> {l_bs_test_zero_tail2, 0};
var_by_index(19) -> {l_bs_match_string, 0};
var_by_index(20) -> {l_is_eq_exact_immed, 0};
var_by_index(21) -> {put_list, 1};
var_by_index(22) -> {is_tuple_of_arity, 0};
var_by_index(23) -> {l_is_eq_exact_immed, 1};
var_by_index(24) -> {get_list, 0};
var_by_index(25) -> {l_put_tuple, 1};
var_by_index(26) -> {move, 5};
var_by_index(27) -> {l_call_ext, 85};
var_by_index(28) -> {l_move_call_ext, 0};
var_by_index(29) -> {return, 0};
var_by_index(30) -> {move2, 2};
var_by_index(31) -> {l_is_ge, 0};
var_by_index(32) -> {l_move_call_last, 0};
var_by_index(33) -> {l_make_fun, 0};
var_by_index(34) -> {is_tuple_of_arity, 2};
var_by_index(35) -> {extract_next_element2, 0};
var_by_index(36) -> {move_deallocate_return, 0};
var_by_index(37) -> {call_bif, 3};
var_by_index(38) -> {l_allocate, 0};
var_by_index(39) -> {l_fetch, 0};
var_by_index(40) -> {l_trim, 0};
var_by_index(41) -> {is_nil, 0};
var_by_index(42) -> {is_nonempty_list, 0};
var_by_index(43) -> {move_return, 25};
var_by_index(44) -> {l_move_call_ext, 1};
var_by_index(45) -> {deallocate_return, 0};
var_by_index(46) -> {case_end, 0};
var_by_index(47) -> {get_list, 1};
var_by_index(48) -> {l_allocate, 1};
var_by_index(49) -> {l_fetch, 1};
var_by_index(50) -> {jump, 0};
var_by_index(51) -> {extract_next_element, 0};
var_by_index(52) -> {put_list, 3};
var_by_index(53) -> {l_is_eq_exact_immed, 2};
var_by_index(54) -> {move2, 3};
var_by_index(55) -> {l_fetch, 2};
var_by_index(56) -> {l_is_eq_exact, 0};
var_by_index(57) -> {call_bif, 8};
var_by_index(58) -> {l_allocate, 2};
var_by_index(59) -> {l_is_eq_exact_immed, 3};
var_by_index(60) -> {get_tuple_element, 2};
var_by_index(61) -> {l_move_call, 26};
var_by_index(62) -> {deallocate_return, 1};
var_by_index(63) -> {move_return, 0};
var_by_index(64) -> {init2, 0};
var_by_index(65) -> {get_tuple_element, 3};
var_by_index(66) -> {put_list, 2};
var_by_index(67) -> {init, 0};
var_by_index(68) -> {move2, 4};
var_by_index(69) -> {l_is_eq_exact_immed, 4};
var_by_index(70) -> {call_bif, 9};
var_by_index(71) -> {l_fetch, 3};
var_by_index(72) -> {deallocate_return, 2};
var_by_index(73) -> {extract_next_element, 1};
var_by_index(74) -> {is_nonempty_list, 1};
var_by_index(75) -> {put_list, 4};
var_by_index(76) -> {l_put_tuple, 2};
var_by_index(77) -> {l_allocate, 3};
var_by_index(78) -> {is_tuple_of_arity, 3};
var_by_index(79) -> {move2, 5};
var_by_index(80) -> {init, 1};
var_by_index(81) -> {get_tuple_element, 4};
var_by_index(82) -> {l_fetch, 4};
var_by_index(83) -> {init3, 0};
var_by_index(84) -> {get_list, 2};
var_by_index(85) -> {l_move_call_ext, 38};
var_by_index(86) -> {allocate_init, 0};
var_by_index(87) -> {l_is_eq_exact_immed, 5};
var_by_index(88) -> {l_trim, 1};
var_by_index(89) -> {test_heap_1_put_list, 0};
var_by_index(90) -> {l_is_lt, 0};
var_by_index(91) -> {l_is_eq_exact_literal, 0};
var_by_index(92) -> {call_bif, 6};
var_by_index(93) -> {call_bif, 45};
var_by_index(94) -> {l_allocate_zero, 0};
var_by_index(95) -> {allocate_heap, 0};
var_by_index(96) -> {is_tuple, 0};
var_by_index(97) -> {move_return, 1};
var_by_index(98) -> {is_nonempty_list, 2};
var_by_index(99) -> {l_allocate_zero, 1};
var_by_index(100) -> {move, 6};
var_by_index(101) -> {l_call_last, 0};
var_by_index(102) -> {init, 2};
var_by_index(103) -> {l_gc_bif1, 0};
var_by_index(104) -> {deallocate_return, 3};
var_by_index(105) -> {get_tuple_element, 5};
var_by_index(106) -> {l_increment, 0};
var_by_index(107) -> {call_bif, 2};
var_by_index(108) -> {is_nonempty_list_allocate, 0};
var_by_index(109) -> {l_select_val_atoms, 0};
var_by_index(110) -> {l_move_call, 0};
var_by_index(111) -> {l_is_eq_exact_immed, 6};
var_by_index(112) -> {call_bif, 5};
var_by_index(113) -> {move_deallocate_return, 1};
var_by_index(114) -> {is_nonempty_list, 3};
var_by_index(115) -> {extract_next_element, 2};
var_by_index(116) -> {is_list, 0};
var_by_index(117) -> {l_select_val2, 3};
var_by_index(118) -> {l_fetch, 5};
var_by_index(119) -> {extract_next_element3, 0};
var_by_index(120) -> {is_nil, 1};
var_by_index(121) -> {move_deallocate_return, 2};
var_by_index(122) -> {l_call_last, 1};
var_by_index(123) -> {l_trim, 2};
var_by_index(124) -> {l_call_last, 2};
var_by_index(125) -> {get_list, 3};
var_by_index(126) -> {l_select_val2, 0};
var_by_index(127) -> {l_move_call_only, 12};
var_by_index(128) -> {is_nil, 2};
var_by_index(129) -> {move2, 6};
var_by_index(130) -> {l_allocate, 4};
var_by_index(131) -> {l_move_call_only, 0};
var_by_index(132) -> {extract_next_element2, 1};
var_by_index(133) -> {move_return, 2};
var_by_index(134) -> {test_arity, 0};
var_by_index(135) -> {move2, 7};
var_by_index(136) -> {l_call_ext, 0};
var_by_index(137) -> {l_new_bs_put_integer_imm, 0};
var_by_index(138) -> {l_select_val2, 4};
var_by_index(139) -> {l_move_call_only, 1};
var_by_index(140) -> {l_select_val2, 1};
var_by_index(141) -> {remove_message, 0};
var_by_index(142) -> {init, 3};
var_by_index(143) -> {l_allocate_zero, 2};
var_by_index(144) -> {l_plus, 0};
var_by_index(145) -> {l_catch, 0};
var_by_index(146) -> {deallocate_return, 4};
var_by_index(147) -> {is_nonempty_list, 4};
var_by_index(148) -> {bif1_body, 0};
var_by_index(149) -> {l_put_tuple, 3};
var_by_index(150) -> {extract_next_element, 3};
var_by_index(151) -> {l_is_eq_exact_immed, 7};
var_by_index(152) -> {move_jump, 14};
var_by_index(153) -> {move, 7};
var_by_index(154) -> {l_allocate_zero, 3};
var_by_index(155) -> {l_move_call_only, 2};
var_by_index(156) -> {l_select_tuple_arity2, 0};
var_by_index(157) -> {l_bs_start_match2, 1};
var_by_index(158) -> {catch_end, 0};
var_by_index(159) -> {move_return, 3};
var_by_index(160) -> {is_nonempty_list, 5};
var_by_index(161) -> {l_is_eq_exact_immed, 8};
var_by_index(162) -> {l_call_last, 3};
var_by_index(163) -> {l_move_call_only, 3};
var_by_index(164) -> {l_call_last, 4};
var_by_index(165) -> {get_list, 4};
var_by_index(166) -> {move_return, 4};
var_by_index(167) -> {move, 8};
var_by_index(168) -> {test_arity, 1};
var_by_index(169) -> {move_return, 5};
var_by_index(170) -> {is_nonempty_list, 6};
var_by_index(171) -> {l_call_fun, 0};
var_by_index(172) -> {l_increment, 1};
var_by_index(173) -> {put_list, 5};
var_by_index(174) -> {init, 4};
var_by_index(175) -> {l_is_eq, 0};
var_by_index(176) -> {l_select_val2, 2};
var_by_index(177) -> {l_move_call_ext, 2};
var_by_index(178) -> {l_call_ext_only, 4};
var_by_index(179) -> {l_bs_get_binary_all_reuse, 0};
var_by_index(180) -> {send, 0};
var_by_index(181) -> {set_tuple_element, 0};
var_by_index(182) -> {bif2_body, 0};
var_by_index(183) -> {extract_next_element2, 2};
var_by_index(184) -> {l_move_call, 1};
var_by_index(185) -> {l_catch, 1};
var_by_index(186) -> {is_nil, 3};
var_by_index(187) -> {move_deallocate_return, 3};
var_by_index(188) -> {call_bif, 10};
var_by_index(189) -> {extract_next_element2, 3};
var_by_index(190) -> {badmatch, 1};
var_by_index(191) -> {is_nonempty_list, 7};
var_by_index(192) -> {l_increment, 2};
var_by_index(193) -> {l_is_eq_exact_immed, 9};
var_by_index(194) -> {case_end, 1};
var_by_index(195) -> {extract_next_element, 4};
var_by_index(196) -> {l_trim, 3};
var_by_index(197) -> {l_move_call_ext_last, 0};
var_by_index(198) -> {is_nonempty_list, 8};
var_by_index(199) -> {l_move_call_last, 1};
var_by_index(200) -> {badmatch, 2};
var_by_index(201) -> {deallocate_return, 5};
var_by_index(202) -> {l_fetch, 6};
var_by_index(203) -> {l_select_val_atoms, 1};
var_by_index(204) -> {l_bs_add, 0};
var_by_index(205) -> {l_allocate, 5};
var_by_index(206) -> {l_select_val_smallints, 0};
var_by_index(207) -> {l_move_call, 2};
var_by_index(208) -> {l_select_tuple_arity2, 1};
var_by_index(209) -> {is_nonempty_list, 9};
var_by_index(210) -> {l_bs_test_zero_tail2, 1};
var_by_index(211) -> {l_loop_rec, 0};
var_by_index(212) -> {l_move_call_ext, 3};
var_by_index(213) -> {is_nil, 4};
var_by_index(214) -> {l_is_ne_exact_immed, 0};
var_by_index(215) -> {l_increment, 3};
var_by_index(216) -> {l_is_ne, 0};
var_by_index(217) -> {l_move_call, 3};
var_by_index(218) -> {l_plus, 1};
var_by_index(219) -> {catch_end, 1};
var_by_index(220) -> {l_move_call, 4};
var_by_index(221) -> {init, 5};
var_by_index(222) -> {l_call_last, 6};
var_by_index(223) -> {l_call_last, 5};
var_by_index(224) -> {l_minus, 0};
var_by_index(225) -> {l_move_call_ext, 4};
var_by_index(226) -> {l_bs_match_string, 1};
var_by_index(227) -> {l_allocate_zero, 4};
var_by_index(228) -> {extract_next_element, 5};
var_by_index(229) -> {l_select_val2, 6};
var_by_index(230) -> {l_bs_init_heap_bin, 0};
var_by_index(231) -> {l_allocate_zero, 5};
var_by_index(232) -> {l_bs_start_match2, 2};
var_by_index(233) -> {l_fetch, 7};
var_by_index(234) -> {l_call_ext_last, 0};
var_by_index(235) -> {is_nonempty_list_allocate, 1};
var_by_index(236) -> {l_bs_restore2, 0};
var_by_index(237) -> {loop_rec_end, 0};
var_by_index(238) -> {call_bif, 11};
var_by_index(239) -> {l_bs_get_utf16, 0};
var_by_index(240) -> {l_fast_element, 1};
var_by_index(241) -> {l_gc_bif1, 1};
var_by_index(242) -> {l_trim, 4};
var_by_index(243) -> {move, 9};
var_by_index(244) -> {wait, 0};
var_by_index(245) -> {l_is_eq_exact_immed, 10};
var_by_index(246) -> {extract_next_element2, 4};
var_by_index(247) -> {is_atom, 0};
var_by_index(248) -> {call_bif, 12};
var_by_index(249) -> {int_code_end, 0};
var_by_index(250) -> {l_call_fun_last, 0};
var_by_index(251) -> {l_move_call_ext_only, 0};
var_by_index(252) -> {get_tuple_element, 6};
var_by_index(253) -> {move_deallocate_return, 4};
var_by_index(254) -> {bs_context_to_binary, 0};
var_by_index(255) -> {init, 6};
var_by_index(256) -> {l_move_call_ext, 5};
var_by_index(257) -> {extract_next_element, 6};
var_by_index(258) -> {self, 0};
var_by_index(259) -> {is_nil, 5};
var_by_index(260) -> {l_move_call_ext, 6};
var_by_index(261) -> {l_call_ext_last, 1};
var_by_index(262) -> {l_call_fun, 1};
var_by_index(263) -> {l_is_eq_exact_immed, 11};
var_by_index(264) -> {l_move_call, 5};
var_by_index(265) -> {l_is_ne_exact_immed, 1};
var_by_index(266) -> {is_tuple, 1};
var_by_index(267) -> {extract_next_element, 7};
var_by_index(268) -> {l_move_call_last, 2};
var_by_index(269) -> {l_times, 0};
var_by_index(270) -> {l_bs_test_unit_8, 0};
var_by_index(271) -> {l_allocate, 6};
var_by_index(272) -> {badmatch, 3};
var_by_index(273) -> {l_move_call_ext_only, 1};
var_by_index(274) -> {l_bs_test_zero_tail2, 2};
var_by_index(275) -> {l_move_call_ext, 7};
var_by_index(276) -> {l_move_call_ext, 8};
var_by_index(277) -> {move_return, 6};
var_by_index(278) -> {l_put_tuple, 4};
var_by_index(279) -> {call_bif, 13};
var_by_index(280) -> {l_catch, 2};
var_by_index(281) -> {bif1_body, 1};
var_by_index(282) -> {l_select_val_smallints, 1};
var_by_index(283) -> {raise, 0};
var_by_index(284) -> {call_bif, 14};
var_by_index(285) -> {is_nil, 6};
var_by_index(286) -> {l_move_call, 6};
var_by_index(287) -> {l_move_call_ext, 9};
var_by_index(288) -> {l_select_val2, 7};
var_by_index(289) -> {is_integer, 0};
var_by_index(290) -> {extract_next_element3, 1};
var_by_index(291) -> {l_minus, 1};
var_by_index(292) -> {is_nonempty_list, 10};
var_by_index(293) -> {call_bif, 15};
var_by_index(294) -> {l_bs_save2, 0};
var_by_index(295) -> {l_call_ext_last, 2};
var_by_index(296) -> {extract_next_element, 8};
var_by_index(297) -> {l_call_ext, 1};
var_by_index(298) -> {l_new_bs_put_binary_all, 0};
var_by_index(299) -> {l_move_call_ext_only, 7};
var_by_index(300) -> {is_nil, 7};
var_by_index(301) -> {deallocate_return, 6};
var_by_index(302) -> {l_move_call_only, 4};
var_by_index(303) -> {self, 1};
var_by_index(304) -> {l_call_ext, 2};
var_by_index(305) -> {l_select_val2, 5};
var_by_index(306) -> {case_end, 2};
var_by_index(307) -> {allocate_heap_zero, 0};
var_by_index(308) -> {call_bif, 16};
var_by_index(309) -> {is_nonempty_list, 11};
var_by_index(310) -> {extract_next_element2, 5};
var_by_index(311) -> {apply, 0};
var_by_index(312) -> {try_end, 0};
var_by_index(313) -> {l_move_call, 7};
var_by_index(314) -> {call_bif, 17};
var_by_index(315) -> {l_fast_element, 0};
var_by_index(316) -> {test_heap_1_put_list, 1};
var_by_index(317) -> {call_bif, 19};
var_by_index(318) -> {call_bif, 18};
var_by_index(319) -> {call_bif, 20};
var_by_index(320) -> {l_bs_test_zero_tail2, 3};
var_by_index(321) -> {l_move_call_ext, 10};
var_by_index(322) -> {is_nil, 8};
var_by_index(323) -> {get_tuple_element, 7};
var_by_index(324) -> {call_bif, 21};
var_by_index(325) -> {l_call_ext, 3};
var_by_index(326) -> {catch_end, 2};
var_by_index(327) -> {l_put_tuple, 5};
var_by_index(328) -> {is_list, 1};
var_by_index(329) -> {extract_next_element3, 2};
var_by_index(330) -> {get_list, 7};
var_by_index(331) -> {l_bif2, 0};
var_by_index(332) -> {call_bif, 22};
var_by_index(333) -> {init, 7};
var_by_index(334) -> {try_end, 1};
var_by_index(335) -> {l_bs_get_integer_32, 0};
var_by_index(336) -> {test_arity, 2};
var_by_index(337) -> {l_trim, 5};
var_by_index(338) -> {l_increment, 4};
var_by_index(339) -> {l_move_call, 8};
var_by_index(340) -> {l_call_ext, 4};
var_by_index(341) -> {extract_next_element, 9};
var_by_index(342) -> {l_move_call_ext, 11};
var_by_index(343) -> {l_is_ne_exact, 0};
var_by_index(344) -> {l_bs_get_binary2, 0};
var_by_index(345) -> {extract_next_element, 24};
var_by_index(346) -> {is_integer, 1};
var_by_index(347) -> {l_band, 0};
var_by_index(348) -> {move_jump, 0};
var_by_index(349) -> {l_is_eq_exact_immed, 12};
var_by_index(350) -> {l_call_fun, 2};
var_by_index(351) -> {move_deallocate_return, 5};
var_by_index(352) -> {l_times, 1};
var_by_index(353) -> {l_move_call_last, 3};
var_by_index(354) -> {put_list, 7};
var_by_index(355) -> {l_call_last, 7};
var_by_index(356) -> {l_move_call_ext_only, 3};
var_by_index(357) -> {l_fast_element, 2};
var_by_index(358) -> {l_is_eq_exact_literal, 7};
var_by_index(359) -> {extract_next_element, 10};
var_by_index(360) -> {extract_next_element2, 6};
var_by_index(361) -> {is_tuple, 2};
var_by_index(362) -> {l_catch, 3};
var_by_index(363) -> {l_call_ext, 5};
var_by_index(364) -> {l_call_ext, 6};
var_by_index(365) -> {l_bif2, 1};
var_by_index(366) -> {l_is_eq_exact_immed, 13};
var_by_index(367) -> {is_binary, 0};
var_by_index(368) -> {l_call_ext, 7};
var_by_index(369) -> {extract_next_element2, 7};
var_by_index(370) -> {l_allocate_zero, 6};
var_by_index(371) -> {l_bsr, 0};
var_by_index(372) -> {l_fetch, 22};
var_by_index(373) -> {move, 10};
var_by_index(374) -> {extract_next_element3, 3};
var_by_index(375) -> {l_is_eq_exact_immed, 14};
var_by_index(376) -> {get_list, 5};
var_by_index(377) -> {is_atom, 1};
var_by_index(378) -> {extract_next_element3, 4};
var_by_index(379) -> {l_bs_get_binary_all2, 0};
var_by_index(380) -> {call_bif, 23};
var_by_index(381) -> {l_move_call_only, 5};
var_by_index(382) -> {call_bif, 24};
var_by_index(383) -> {is_nonempty_list, 12};
var_by_index(384) -> {l_is_eq_exact_immed, 15};
var_by_index(385) -> {l_fetch, 8};
var_by_index(386) -> {l_is_eq_exact_literal, 1};
var_by_index(387) -> {l_move_call_ext, 12};
var_by_index(388) -> {l_bs_get_integer_8, 0};
var_by_index(389) -> {l_is_ne_exact_immed, 2};
var_by_index(390) -> {put_list, 6};
var_by_index(391) -> {is_nil, 9};
var_by_index(392) -> {l_bsl, 0};
var_by_index(393) -> {l_select_val2, 9};
var_by_index(394) -> {is_list, 2};
var_by_index(395) -> {l_allocate_zero, 9};
var_by_index(396) -> {l_put_tuple, 6};
var_by_index(397) -> {l_call_ext, 8};
var_by_index(398) -> {l_bs_init_fail, 0};
var_by_index(399) -> {get_list, 6};
var_by_index(400) -> {l_bif2, 2};
var_by_index(401) -> {deallocate_return, 7};
var_by_index(402) -> {l_bs_get_integer_8, 1};
var_by_index(403) -> {set_tuple_element, 1};
var_by_index(404) -> {l_move_call_ext, 13};
var_by_index(405) -> {l_select_val2, 16};
var_by_index(406) -> {call_bif, 26};
var_by_index(407) -> {call_bif, 25};
var_by_index(408) -> {l_call_ext, 9};
var_by_index(409) -> {l_move_call, 9};
var_by_index(410) -> {l_is_eq_exact_literal, 2};
var_by_index(411) -> {l_bs_get_integer_32, 1};
var_by_index(412) -> {extract_next_element, 11};
var_by_index(413) -> {l_is_eq_exact_literal, 3};
var_by_index(414) -> {l_is_eq_exact_immed, 16};
var_by_index(415) -> {l_fetch, 9};
var_by_index(416) -> {l_bif2, 3};
var_by_index(417) -> {is_nil, 10};
var_by_index(418) -> {l_bsl, 1};
var_by_index(419) -> {l_bs_test_zero_tail2, 5};
var_by_index(420) -> {l_trim, 6};
var_by_index(421) -> {l_rem, 0};
var_by_index(422) -> {move2, 8};
var_by_index(423) -> {l_move_call_ext, 14};
var_by_index(424) -> {timeout, 0};
var_by_index(425) -> {is_binary, 1};
var_by_index(426) -> {catch_end, 3};
var_by_index(427) -> {l_move_call_ext_last, 1};
var_by_index(428) -> {l_call_last, 8};
var_by_index(429) -> {l_allocate_zero, 7};
var_by_index(430) -> {l_select_val2, 10};
var_by_index(431) -> {l_fetch, 10};
var_by_index(432) -> {l_fmul, 0};
var_by_index(433) -> {l_bs_match_string, 2};
var_by_index(434) -> {call_bif, 27};
var_by_index(435) -> {extract_next_element3, 10};
var_by_index(436) -> {l_gc_bif1, 2};
var_by_index(437) -> {move_deallocate_return, 6};
var_by_index(438) -> {l_allocate, 7};
var_by_index(439) -> {l_move_call, 10};
var_by_index(440) -> {l_catch, 4};
var_by_index(441) -> {is_nonempty_list, 36};
var_by_index(442) -> {l_bs_get_integer_small_imm, 0};
var_by_index(443) -> {extract_next_element, 12};
var_by_index(444) -> {l_is_eq_exact_immed, 36};
var_by_index(445) -> {l_call_ext, 10};
var_by_index(446) -> {move_jump, 1};
var_by_index(447) -> {l_fcheckerror, 0};
var_by_index(448) -> {fclearerror, 0};
var_by_index(449) -> {move_return, 7};
var_by_index(450) -> {l_bs_append, 0};
var_by_index(451) -> {node, 0};
var_by_index(452) -> {l_move_call, 11};
var_by_index(453) -> {extract_next_element2, 16};
var_by_index(454) -> {l_move_call_last, 4};
var_by_index(455) -> {l_is_eq_exact_immed, 17};
var_by_index(456) -> {l_call_ext, 11};
var_by_index(457) -> {extract_next_element, 13};
var_by_index(458) -> {l_move_call_ext_only, 2};
var_by_index(459) -> {l_is_ne_exact_immed, 11};
var_by_index(460) -> {l_is_eq_exact_immed, 18};
var_by_index(461) -> {l_get, 1};
var_by_index(462) -> {l_element, 2};
var_by_index(463) -> {is_integer, 2};
var_by_index(464) -> {is_integer, 7};
var_by_index(465) -> {l_move_call_ext_last, 4};
var_by_index(466) -> {l_bif2, 4};
var_by_index(467) -> {l_move_call_ext, 16};
var_by_index(468) -> {l_call_fun, 3};
var_by_index(469) -> {l_move_call, 12};
var_by_index(470) -> {call_bif, 28};
var_by_index(471) -> {is_nonempty_list, 13};
var_by_index(472) -> {try_end, 2};
var_by_index(473) -> {is_nil, 11};
var_by_index(474) -> {l_select_tuple_arity, 1};
var_by_index(475) -> {is_tuple, 3};
var_by_index(476) -> {l_move_call_ext_last, 2};
var_by_index(477) -> {node, 1};
var_by_index(478) -> {is_nonempty_list, 14};
var_by_index(479) -> {l_bs_restore2, 1};
var_by_index(480) -> {l_move_call_ext, 17};
var_by_index(481) -> {l_band, 1};
var_by_index(482) -> {l_is_eq_exact_immed, 19};
var_by_index(483) -> {l_get, 4};
var_by_index(484) -> {call_bif, 29};
var_by_index(485) -> {call_bif, 1};
var_by_index(486) -> {l_fetch, 11};
var_by_index(487) -> {l_gc_bif1, 3};
var_by_index(488) -> {is_nil, 12};
var_by_index(489) -> {l_move_call_only, 6};
var_by_index(490) -> {l_move_call, 13};
var_by_index(491) -> {system_limit, 0};
var_by_index(492) -> {l_element, 0};
var_by_index(493) -> {l_select_tuple_arity, 0};
var_by_index(494) -> {bif2_body, 1};
var_by_index(495) -> {is_float, 1};
var_by_index(496) -> {extract_next_element2, 8};
var_by_index(497) -> {l_select_val2, 8};
var_by_index(498) -> {is_integer_allocate, 0};
var_by_index(499) -> {is_atom, 2};
var_by_index(500) -> {l_int_div, 0};
var_by_index(501) -> {l_get, 2};
var_by_index(502) -> {l_gc_bif1, 5};
var_by_index(503) -> {l_move_call_ext, 18};
var_by_index(504) -> {is_nil, 29};
var_by_index(505) -> {l_is_eq_exact_immed, 20};
var_by_index(506) -> {call_bif, 30};
var_by_index(507) -> {l_bor, 0};
var_by_index(508) -> {l_bif1, 0};
var_by_index(509) -> {l_catch, 5};
var_by_index(510) -> {l_get, 0};
var_by_index(511) -> {l_fetch, 12};
var_by_index(512) -> {l_call_ext, 13};
var_by_index(513) -> {l_call_ext, 12};
var_by_index(514) -> {is_tuple, 9};
var_by_index(515) -> {try_end, 3};
var_by_index(516) -> {init, 8};
var_by_index(517) -> {call_bif, 32};
var_by_index(518) -> {call_bif, 31};
var_by_index(519) -> {is_nil, 13};
var_by_index(520) -> {apply_last, 0};
var_by_index(521) -> {call_bif, 33};
var_by_index(522) -> {l_int_div, 1};
var_by_index(523) -> {call_bif, 34};
var_by_index(524) -> {extract_next_element, 14};
var_by_index(525) -> {put_list, 9};
var_by_index(526) -> {is_nonempty_list, 15};
var_by_index(527) -> {case_end, 11};
var_by_index(528) -> {l_bs_skip_bits2, 0};
var_by_index(529) -> {l_call_ext, 14};
var_by_index(530) -> {deallocate_return, 8};
var_by_index(531) -> {l_call_ext_last, 3};
var_by_index(532) -> {l_move_call_ext, 19};
var_by_index(533) -> {l_is_ne_exact_immed, 3};
var_by_index(534) -> {extract_next_element3, 5};
var_by_index(535) -> {is_integer, 3};
var_by_index(536) -> {l_trim, 7};
var_by_index(537) -> {l_is_eq_exact_immed, 21};
var_by_index(538) -> {l_increment, 8};
var_by_index(539) -> {call_bif, 4};
var_by_index(540) -> {is_nonempty_list, 16};
var_by_index(541) -> {is_list, 7};
var_by_index(542) -> {l_element, 4};
var_by_index(543) -> {extract_next_element3, 6};
var_by_index(544) -> {l_is_eq_exact_literal, 4};
var_by_index(545) -> {test_arity, 3};
var_by_index(546) -> {move_deallocate_return, 7};
var_by_index(547) -> {l_move_call_ext_only, 4};
var_by_index(548) -> {l_fadd, 0};
var_by_index(549) -> {l_call_ext, 16};
var_by_index(550) -> {l_call_ext, 15};
var_by_index(551) -> {try_end, 5};
var_by_index(552) -> {try_end, 4};
var_by_index(553) -> {l_move_call_ext, 20};
var_by_index(554) -> {l_bs_match_string, 3};
var_by_index(555) -> {call_bif, 35};
var_by_index(556) -> {l_call_ext, 17};
var_by_index(557) -> {fmove_1, 0};
var_by_index(558) -> {l_increment, 6};
var_by_index(559) -> {if_end, 0};
var_by_index(560) -> {l_increment, 5};
var_by_index(561) -> {l_call_ext, 18};
var_by_index(562) -> {is_integer, 4};
var_by_index(563) -> {l_bs_get_utf8, 0};
var_by_index(564) -> {is_list, 3};
var_by_index(565) -> {is_atom, 3};
var_by_index(566) -> {l_fetch, 13};
var_by_index(567) -> {l_bs_init_bits_fail, 0};
var_by_index(568) -> {call_bif, 36};
var_by_index(569) -> {l_call_ext, 19};
var_by_index(570) -> {l_bs_test_zero_tail2, 4};
var_by_index(571) -> {fconv, 0};
var_by_index(572) -> {case_end, 3};
var_by_index(573) -> {catch_end, 4};
var_by_index(574) -> {l_make_export, 0};
var_by_index(575) -> {l_rem, 1};
var_by_index(576) -> {self, 2};
var_by_index(577) -> {fmove_2, 0};
var_by_index(578) -> {l_bor, 1};
var_by_index(579) -> {l_call_ext_last, 4};
var_by_index(580) -> {call_bif, 37};
var_by_index(581) -> {l_call_last, 9};
var_by_index(582) -> {bif1_body, 2};
var_by_index(583) -> {is_binary, 2};
var_by_index(584) -> {l_fetch, 14};
var_by_index(585) -> {l_call_ext, 20};
var_by_index(586) -> {l_move_call_ext, 21};
var_by_index(587) -> {l_bs_skip_bits_all2, 0};
var_by_index(588) -> {l_catch, 7};
var_by_index(589) -> {l_move_call_ext, 22};
var_by_index(590) -> {extract_next_element, 15};
var_by_index(591) -> {badmatch, 4};
var_by_index(592) -> {l_move_call, 14};
var_by_index(593) -> {self, 5};
var_by_index(594) -> {get_tuple_element, 8};
var_by_index(595) -> {l_move_call_ext, 23};
var_by_index(596) -> {l_move_call_ext, 24};
var_by_index(597) -> {l_call_ext, 21};
var_by_index(598) -> {l_move_call_only, 7};
var_by_index(599) -> {put_list, 8};
var_by_index(600) -> {l_is_eq_exact_immed, 22};
var_by_index(601) -> {is_nonempty_list_test_heap, 0};
var_by_index(602) -> {is_tuple, 4};
var_by_index(603) -> {extract_next_element2, 9};
var_by_index(604) -> {case_end, 4};
var_by_index(605) -> {l_is_function2, 0};
var_by_index(606) -> {bif2_body, 3};
var_by_index(607) -> {fmove_2, 1};
var_by_index(608) -> {l_call_ext, 22};
var_by_index(609) -> {extract_next_element, 16};
var_by_index(610) -> {extract_next_element2, 10};
var_by_index(611) -> {move_jump, 2};
var_by_index(612) -> {move_return, 8};
var_by_index(613) -> {is_nonempty_list, 17};
var_by_index(614) -> {is_pid, 0};
var_by_index(615) -> {l_jump_on_val, 0};
var_by_index(616) -> {l_get, 3};
var_by_index(617) -> {bif1_body, 3};
var_by_index(618) -> {l_select_val2, 11};
var_by_index(619) -> {l_allocate_zero, 8};
var_by_index(620) -> {is_list, 4};
var_by_index(621) -> {l_is_ne_exact_immed, 4};
var_by_index(622) -> {fmove_1, 2};
var_by_index(623) -> {bif1_body, 4};
var_by_index(624) -> {fmove_1, 1};
var_by_index(625) -> {is_nonempty_list, 18};
var_by_index(626) -> {l_bs_test_unit_8, 3};
var_by_index(627) -> {l_fetch, 15};
var_by_index(628) -> {l_is_eq_exact_immed, 24};
var_by_index(629) -> {put_list, 10};
var_by_index(630) -> {call_bif, 38};
var_by_index(631) -> {l_gc_bif1, 4};
var_by_index(632) -> {extract_next_element, 17};
var_by_index(633) -> {is_atom, 6};
var_by_index(634) -> {l_move_call, 15};
var_by_index(635) -> {l_allocate, 10};
var_by_index(636) -> {l_move_call_ext_last, 3};
var_by_index(637) -> {l_call_ext, 23};
var_by_index(638) -> {l_element, 1};
var_by_index(639) -> {move_deallocate_return, 8};
var_by_index(640) -> {l_new_bs_put_integer, 0};
var_by_index(641) -> {l_call_ext, 24};
var_by_index(642) -> {l_move_call_last, 5};
var_by_index(643) -> {l_move_call_ext, 25};
var_by_index(644) -> {init, 9};
var_by_index(645) -> {l_allocate, 8};
var_by_index(646) -> {l_call_ext, 25};
var_by_index(647) -> {l_fdiv, 0};
var_by_index(648) -> {bs_context_to_binary, 4};
var_by_index(649) -> {l_bif2, 6};
var_by_index(650) -> {l_call_ext_last, 6};
var_by_index(651) -> {get_list, 8};
var_by_index(652) -> {node, 4};
var_by_index(653) -> {l_call_ext, 26};
var_by_index(654) -> {extract_next_element, 18};
var_by_index(655) -> {deallocate_return, 9};
var_by_index(656) -> {l_move_call_ext, 15};
var_by_index(657) -> {is_binary, 3};
var_by_index(658) -> {move_deallocate_return, 9};
var_by_index(659) -> {l_call_ext, 27};
var_by_index(660) -> {is_nonempty_list, 19};
var_by_index(661) -> {l_select_val_atoms, 2};
var_by_index(662) -> {badmatch, 17};
var_by_index(663) -> {call_bif, 39};
var_by_index(664) -> {l_call_ext, 28};
var_by_index(665) -> {extract_next_element2, 11};
var_by_index(666) -> {badmatch, 5};
var_by_index(667) -> {case_end, 5};
var_by_index(668) -> {l_bs_restore2, 2};
var_by_index(669) -> {l_fetch, 16};
var_by_index(670) -> {l_bs_get_integer, 0};
var_by_index(671) -> {l_is_eq_exact_immed, 25};
var_by_index(672) -> {l_call_ext, 29};
var_by_index(673) -> {move_return, 9};
var_by_index(674) -> {is_function, 2};
var_by_index(675) -> {l_bif1, 2};
var_by_index(676) -> {l_move_call_ext, 26};
var_by_index(677) -> {call_bif, 40};
var_by_index(678) -> {l_call_ext, 30};
var_by_index(679) -> {case_end, 6};
var_by_index(680) -> {l_move_call_ext, 27};
var_by_index(681) -> {catch_end, 5};
var_by_index(682) -> {l_bs_get_binary_imm2, 0};
var_by_index(683) -> {l_move_call_ext, 28};
var_by_index(684) -> {call_bif, 42};
var_by_index(685) -> {call_bif, 41};
var_by_index(686) -> {l_call_ext, 32};
var_by_index(687) -> {l_call_ext, 31};
var_by_index(688) -> {l_bs_test_unit_8, 1};
var_by_index(689) -> {l_move_call, 16};
var_by_index(690) -> {l_bsr, 1};
var_by_index(691) -> {l_move_call_ext, 29};
var_by_index(692) -> {l_bs_skip_bits_imm2, 0};
var_by_index(693) -> {l_move_call_ext, 30};
var_by_index(694) -> {l_call_ext, 34};
var_by_index(695) -> {l_call_ext, 33};
var_by_index(696) -> {is_nil, 15};
var_by_index(697) -> {is_nil, 14};
var_by_index(698) -> {badmatch, 6};
var_by_index(699) -> {l_call_last, 11};
var_by_index(700) -> {fconv, 1};
var_by_index(701) -> {is_boolean, 0};
var_by_index(702) -> {l_is_ne_exact_immed, 5};
var_by_index(703) -> {call_bif, 43};
var_by_index(704) -> {l_call_ext, 35};
var_by_index(705) -> {is_nil, 16};
var_by_index(706) -> {l_move_call_only, 8};
var_by_index(707) -> {l_bs_test_unit_8, 2};
var_by_index(708) -> {catch_end, 7};
var_by_index(709) -> {l_bs_get_utf16, 1};
var_by_index(710) -> {get_list, 9};
var_by_index(711) -> {l_plus, 2};
var_by_index(712) -> {deallocate_return, 12};
var_by_index(713) -> {l_element, 3};
var_by_index(714) -> {move_jump, 3};
var_by_index(715) -> {l_bs_put_string, 0};
var_by_index(716) -> {is_pid, 1};
var_by_index(717) -> {is_atom, 4};
var_by_index(718) -> {l_select_tuple_arity, 2};
var_by_index(719) -> {l_call_ext, 36};
var_by_index(720) -> {extract_next_element, 19};
var_by_index(721) -> {case_end, 7};
var_by_index(722) -> {l_catch, 6};
var_by_index(723) -> {l_call_ext, 38};
var_by_index(724) -> {l_call_ext, 37};
var_by_index(725) -> {move_jump, 4};
var_by_index(726) -> {is_nil, 17};
var_by_index(727) -> {is_list, 5};
var_by_index(728) -> {try_case_end, 0};
var_by_index(729) -> {l_bs_get_binary_all2, 1};
var_by_index(730) -> {move, 11};
var_by_index(731) -> {l_move_call_last, 6};
var_by_index(732) -> {put_list, 14};
var_by_index(733) -> {move_jump, 5};
var_by_index(734) -> {move_return, 10};
var_by_index(735) -> {l_is_eq_exact_literal, 5};
var_by_index(736) -> {bif2_body, 2};
var_by_index(737) -> {get_tuple_element, 9};
var_by_index(738) -> {put_list, 11};
var_by_index(739) -> {l_select_val2, 12};
var_by_index(740) -> {call_bif, 44};
var_by_index(741) -> {is_nonempty_list, 20};
var_by_index(742) -> {l_fsub, 0};
var_by_index(743) -> {l_move_call_ext, 31};
var_by_index(744) -> {bif1_body, 5};
var_by_index(745) -> {l_call_ext, 39};
var_by_index(746) -> {extract_next_element3, 7};
var_by_index(747) -> {l_bs_start_match2, 3};
var_by_index(748) -> {l_trim, 8};
var_by_index(749) -> {bs_context_to_binary, 1};
var_by_index(750) -> {l_call_ext, 40};
var_by_index(751) -> {move_return, 11};
var_by_index(752) -> {l_call_fun, 4};
var_by_index(753) -> {l_is_eq_exact_literal, 6};
var_by_index(754) -> {l_is_ne_exact_immed, 6};
var_by_index(755) -> {test_heap_1_put_list, 2};
var_by_index(756) -> {test_heap_1_put_list, 3};
var_by_index(757) -> {l_is_eq_exact_immed, 26};
var_by_index(758) -> {self, 3};
var_by_index(759) -> {l_call_ext, 41};
var_by_index(760) -> {l_move_call_ext, 33};
var_by_index(761) -> {init, 10};
var_by_index(762) -> {l_bs_skip_bits_imm2, 1};
var_by_index(763) -> {l_call_ext, 42};
var_by_index(764) -> {extract_next_element2, 12};
var_by_index(765) -> {badmatch, 7};
var_by_index(766) -> {l_move_call_ext_only, 5};
var_by_index(767) -> {l_call_ext, 43};
var_by_index(768) -> {move_jump, 6};
var_by_index(769) -> {is_nil, 18};
var_by_index(770) -> {l_call_ext_only, 0};
var_by_index(771) -> {l_fetch, 17};
var_by_index(772) -> {l_move_call_ext, 34};
var_by_index(773) -> {l_move_call_ext, 35};
var_by_index(774) -> {l_is_eq_exact_immed, 27};
var_by_index(775) -> {l_bs_append, 1};
var_by_index(776) -> {l_bif2, 5};
var_by_index(777) -> {l_bs_get_binary2, 1};
var_by_index(778) -> {l_bs_get_integer_small_imm, 1};
var_by_index(779) -> {l_call_ext, 47};
var_by_index(780) -> {l_call_ext, 46};
var_by_index(781) -> {l_call_ext, 45};
var_by_index(782) -> {l_call_ext, 44};
var_by_index(783) -> {move_return, 12};
var_by_index(784) -> {l_bs_save2, 1};
var_by_index(785) -> {is_function, 0};
var_by_index(786) -> {l_bs_get_integer_imm, 0};
var_by_index(787) -> {l_move_call_ext_only, 6};
var_by_index(788) -> {l_call_ext, 48};
var_by_index(789) -> {l_move_call, 17};
var_by_index(790) -> {l_is_ne_exact_immed, 7};
var_by_index(791) -> {l_call_ext, 50};
var_by_index(792) -> {l_call_ext, 49};
var_by_index(793) -> {is_integer, 5};
var_by_index(794) -> {move_return, 13};
var_by_index(795) -> {l_bs_put_string, 1};
var_by_index(796) -> {try_end, 7};
var_by_index(797) -> {l_yield, 0};
var_by_index(798) -> {l_move_call, 18};
var_by_index(799) -> {l_fetch, 18};
var_by_index(800) -> {l_is_eq_exact_immed, 28};
var_by_index(801) -> {l_new_bs_put_integer, 1};
var_by_index(802) -> {node, 2};
var_by_index(803) -> {l_call_ext, 51};
var_by_index(804) -> {move_jump, 7};
var_by_index(805) -> {case_end, 9};
var_by_index(806) -> {case_end, 8};
var_by_index(807) -> {is_nonempty_list, 22};
var_by_index(808) -> {is_nonempty_list, 21};
var_by_index(809) -> {l_move_call, 19};
var_by_index(810) -> {l_move_call_ext, 37};
var_by_index(811) -> {get_list, 11};
var_by_index(812) -> {l_fetch, 19};
var_by_index(813) -> {l_new_bs_put_float_imm, 1};
var_by_index(814) -> {l_move_call, 20};
var_by_index(815) -> {l_call_ext_only, 1};
var_by_index(816) -> {l_gc_bif1, 6};
var_by_index(817) -> {l_bif1, 1};
var_by_index(818) -> {l_move_call, 21};
var_by_index(819) -> {l_is_ne_exact_literal, 0};
var_by_index(820) -> {l_bs_put_string, 2};
var_by_index(821) -> {l_call_ext, 52};
var_by_index(822) -> {l_is_eq_exact_immed, 23};
var_by_index(823) -> {extract_next_element, 20};
var_by_index(824) -> {is_nil, 19};
var_by_index(825) -> {badmatch, 8};
var_by_index(826) -> {catch_end, 6};
var_by_index(827) -> {l_is_function2, 1};
var_by_index(828) -> {l_call_ext, 53};
var_by_index(829) -> {move_return, 14};
var_by_index(830) -> {badmatch, 9};
var_by_index(831) -> {self, 4};
var_by_index(832) -> {l_call_ext, 56};
var_by_index(833) -> {l_call_ext, 55};
var_by_index(834) -> {l_call_ext, 54};
var_by_index(835) -> {l_call_ext_last, 5};
var_by_index(836) -> {l_move_call, 23};
var_by_index(837) -> {l_move_call, 22};
var_by_index(838) -> {l_select_tuple_arity, 3};
var_by_index(839) -> {l_apply, 0};
var_by_index(840) -> {init, 16};
var_by_index(841) -> {init, 11};
var_by_index(842) -> {l_move_call_last, 8};
var_by_index(843) -> {l_move_call_last, 7};
var_by_index(844) -> {l_call_ext, 59};
var_by_index(845) -> {l_call_ext, 58};
var_by_index(846) -> {l_call_ext, 57};
var_by_index(847) -> {extract_next_element2, 13};
var_by_index(848) -> {l_new_bs_put_integer_imm, 1};
var_by_index(849) -> {try_end, 6};
var_by_index(850) -> {deallocate_return, 10};
var_by_index(851) -> {l_move_call, 24};
var_by_index(852) -> {l_fetch, 20};
var_by_index(853) -> {get_list, 10};
var_by_index(854) -> {l_allocate, 9};
var_by_index(855) -> {bs_init_writable, 0};
var_by_index(856) -> {l_call_ext, 60};
var_by_index(857) -> {extract_next_element, 21};
var_by_index(858) -> {extract_next_element3, 8};
var_by_index(859) -> {is_integer, 6};
var_by_index(860) -> {move_jump, 8};
var_by_index(861) -> {badmatch, 10};
var_by_index(862) -> {is_nonempty_list, 23};
var_by_index(863) -> {l_bs_private_append, 0};
var_by_index(864) -> {deallocate_return, 11};
var_by_index(865) -> {l_move_call, 25};
var_by_index(866) -> {l_call_ext, 63};
var_by_index(867) -> {l_call_ext, 62};
var_by_index(868) -> {l_call_ext, 61};
var_by_index(869) -> {move_jump, 9};
var_by_index(870) -> {move_return, 16};
var_by_index(871) -> {move_return, 15};
var_by_index(872) -> {bs_context_to_binary, 2};
var_by_index(873) -> {l_jump_on_val, 1};
var_by_index(874) -> {l_increment, 7};
var_by_index(875) -> {l_is_ne_exact_immed, 8};
var_by_index(876) -> {l_call_ext, 67};
var_by_index(877) -> {l_call_ext, 66};
var_by_index(878) -> {l_call_ext, 65};
var_by_index(879) -> {l_call_ext, 64};
var_by_index(880) -> {extract_next_element2, 14};
var_by_index(881) -> {put_list, 13};
var_by_index(882) -> {is_float, 0};
var_by_index(883) -> {l_is_eq_exact_immed, 29};
var_by_index(884) -> {l_select_val2, 14};
var_by_index(885) -> {l_call_ext, 69};
var_by_index(886) -> {l_call_ext, 68};
var_by_index(887) -> {extract_next_element3, 9};
var_by_index(888) -> {move_return, 17};
var_by_index(889) -> {is_nonempty_list, 25};
var_by_index(890) -> {is_nonempty_list, 24};
var_by_index(891) -> {l_select_tuple_arity2, 2};
var_by_index(892) -> {is_atom, 5};
var_by_index(893) -> {l_call_ext_only, 2};
var_by_index(894) -> {l_is_ne_exact_immed, 9};
var_by_index(895) -> {node, 3};
var_by_index(896) -> {is_tuple, 5};
var_by_index(897) -> {l_call_ext, 73};
var_by_index(898) -> {l_call_ext, 72};
var_by_index(899) -> {l_call_ext, 71};
var_by_index(900) -> {l_call_ext, 70};
var_by_index(901) -> {extract_next_element, 22};
var_by_index(902) -> {wait_timeout, 0};
var_by_index(903) -> {extract_next_element2, 15};
var_by_index(904) -> {is_nil, 20};
var_by_index(905) -> {is_nonempty_list, 26};
var_by_index(906) -> {l_wait_timeout, 2};
var_by_index(907) -> {l_minus, 2};
var_by_index(908) -> {is_tuple, 6};
var_by_index(909) -> {l_call_ext, 79};
var_by_index(910) -> {l_call_ext, 78};
var_by_index(911) -> {l_call_ext, 77};
var_by_index(912) -> {l_call_ext, 76};
var_by_index(913) -> {l_call_ext, 75};
var_by_index(914) -> {l_call_ext, 74};
var_by_index(915) -> {l_call_last, 10};
var_by_index(916) -> {l_bs_test_tail_imm2, 0};
var_by_index(917) -> {move_jump, 10};
var_by_index(918) -> {move_return, 18};
var_by_index(919) -> {is_integer_allocate, 1};
var_by_index(920) -> {is_nonempty_list, 27};
var_by_index(921) -> {l_new_bs_put_float_imm, 0};
var_by_index(922) -> {l_fetch, 21};
var_by_index(923) -> {move, 12};
var_by_index(924) -> {move2, 9};
var_by_index(925) -> {l_bs_skip_bits_all2, 1};
var_by_index(926) -> {is_tuple, 7};
var_by_index(927) -> {l_call_ext, 84};
var_by_index(928) -> {l_call_ext, 83};
var_by_index(929) -> {l_call_ext, 82};
var_by_index(930) -> {l_call_ext, 81};
var_by_index(931) -> {l_call_ext, 80};
var_by_index(932) -> {l_is_eq_exact_immed, 30};
var_by_index(933) -> {is_nil, 21};
var_by_index(934) -> {recv_mark, 0};
var_by_index(935) -> {raise, 1};
var_by_index(936) -> {case_end, 10};
var_by_index(937) -> {is_function, 1};
var_by_index(938) -> {l_call_ext_only, 3};
var_by_index(939) -> {l_recv_set, 0};
var_by_index(940) -> {l_bs_skip_bits_all2, 2};
var_by_index(941) -> {l_fast_element, 3};
var_by_index(942) -> {l_trim, 11};
var_by_index(943) -> {l_times, 2};
var_by_index(944) -> {bs_context_to_binary, 3};
var_by_index(945) -> {l_move_call_ext, 32};
var_by_index(946) -> {l_is_eq_exact_immed, 31};
var_by_index(947) -> {is_port, 0};
var_by_index(948) -> {l_bs_get_float2, 0};
var_by_index(949) -> {l_bs_get_utf8, 1};
var_by_index(950) -> {l_select_val2, 15};
var_by_index(951) -> {l_select_tuple_arity, 4};
var_by_index(952) -> {test_heap_1_put_list, 4};
var_by_index(953) -> {is_map, 0};
var_by_index(954) -> {l_trim, 9};
var_by_index(955) -> {badmatch, 11};
var_by_index(956) -> {l_apply_fun, 0};
var_by_index(957) -> {init, 12};
var_by_index(958) -> {l_is_eq_exact_immed, 32};
var_by_index(959) -> {extract_next_element, 23};
var_by_index(960) -> {l_move_call_only, 10};
var_by_index(961) -> {l_move_call_only, 9};
var_by_index(962) -> {l_is_eq_exact_immed, 33};
var_by_index(963) -> {l_is_ne_exact_immed, 10};
var_by_index(964) -> {move_return, 19};
var_by_index(965) -> {badmatch, 13};
var_by_index(966) -> {badmatch, 12};
var_by_index(967) -> {l_bs_get_integer_16, 0};
var_by_index(968) -> {l_bs_get_binary_all_reuse, 1};
var_by_index(969) -> {l_is_eq_exact_immed, 34};
var_by_index(970) -> {move_jump, 11};
var_by_index(971) -> {move_return, 21};
var_by_index(972) -> {move_return, 20};
var_by_index(973) -> {l_move_call_only, 11};
var_by_index(974) -> {badmatch, 14};
var_by_index(975) -> {is_list, 6};
var_by_index(976) -> {l_bs_init_fail, 1};
var_by_index(977) -> {l_move_call_ext, 36};
var_by_index(978) -> {is_tuple, 8};
var_by_index(979) -> {move_jump, 13};
var_by_index(980) -> {move_jump, 12};
var_by_index(981) -> {move_return, 22};
var_by_index(982) -> {is_nil, 22};
var_by_index(983) -> {is_nonempty_list, 29};
var_by_index(984) -> {is_nonempty_list, 28};
var_by_index(985) -> {l_bs_init, 0};
var_by_index(986) -> {l_bs_restore2, 3};
var_by_index(987) -> {move, 13};
var_by_index(988) -> {l_bs_get_binary_imm2, 1};
var_by_index(989) -> {is_nonempty_list, 30};
var_by_index(990) -> {l_bs_init_bits, 0};
var_by_index(991) -> {l_bs_put_utf16, 0};
var_by_index(992) -> {is_bitstr, 0};
var_by_index(993) -> {l_bs_validate_unicode, 0};
var_by_index(994) -> {is_nonempty_list, 32};
var_by_index(995) -> {is_nonempty_list, 31};
var_by_index(996) -> {l_bs_save2, 2};
var_by_index(997) -> {l_bs_utf16_size, 0};
var_by_index(998) -> {l_bs_get_binary2, 2};
var_by_index(999) -> {l_is_eq_exact_immed, 35};
var_by_index(1000) -> {get_tuple_element, 10};
var_by_index(1001) -> {l_bs_get_integer_32, 2};
var_by_index(1002) -> {move_return, 24};
var_by_index(1003) -> {move_return, 23};
var_by_index(1004) -> {is_nil, 23};
var_by_index(1005) -> {badmatch, 15};
var_by_index(1006) -> {is_nonempty_list, 33};
var_by_index(1007) -> {move, 14};
var_by_index(1008) -> {l_bs_add, 1};
var_by_index(1009) -> {is_reference, 0};
var_by_index(1010) -> {is_nil, 26};
var_by_index(1011) -> {is_nil, 25};
var_by_index(1012) -> {is_nil, 24};
var_by_index(1013) -> {l_new_bs_put_binary, 0};
var_by_index(1014) -> {badmatch, 16};
var_by_index(1015) -> {is_nonempty_list, 34};
var_by_index(1016) -> {init, 13};
var_by_index(1017) -> {is_nil, 28};
var_by_index(1018) -> {is_nil, 27};
var_by_index(1019) -> {put_list, 12};
var_by_index(1020) -> {is_nonempty_list, 35};
var_by_index(1021) -> {l_bs_validate_unicode_retract, 0};
var_by_index(1022) -> {l_wait_timeout, 0};
var_by_index(1023) -> {l_gc_bif2, 0};
var_by_index(1024) -> {init, 14};
var_by_index(1025) -> {l_fast_element, 4};
var_by_index(1026) -> {l_trim, 10};
var_by_index(1027) -> {l_new_bs_put_binary_all, 1};
var_by_index(1028) -> {l_apply_last, 0};
var_by_index(1029) -> {init, 15};
var_by_index(1030) -> {is_number, 0};
var_by_index(1031) -> {l_int_bnot, 0};
var_by_index(1032) -> {l_bs_put_utf8, 0};
var_by_index(1033) -> {l_new_bs_put_float, 0};
var_by_index(1034) -> {l_select_val2, 13};
var_by_index(1035) -> {l_bs_utf8_size, 0};
var_by_index(1036) -> {l_wait_timeout, 1};
var_by_index(1037) -> {fmove_2, 2};
var_by_index(1038) -> {l_jump_on_val, 2};
var_by_index(1039) -> {l_bs_get_binary_imm2, 2};
var_by_index(1040) -> {l_fnegate, 0};
var_by_index(1041) -> {get_list, 12};
var_by_index(1042) -> {l_bs_get_integer_imm, 1};
var_by_index(1043) -> {bif1_body, 6};
var_by_index(1044) -> {l_bs_get_binary_all_reuse, 2};
var_by_index(1045) -> {l_bxor, 0};
var_by_index(1046) -> {l_new_bs_put_integer_imm, 2};
var_by_index(1047) -> {l_int_div, 2};
var_by_index(1048) -> {l_gc_bif3, 0};
var_by_index(1049) -> {l_apply_only, 0};
var_by_index(1050) -> {l_bor, 2};
var_by_index(1051) -> {l_bs_start_match2, 4};
var_by_index(1052) -> {l_rem, 2};
var_by_index(1053) -> {l_bsl, 2};
var_by_index(1054) -> {l_new_bs_put_binary_imm, 0};
var_by_index(1055) -> {l_apply_fun_only, 0};
var_by_index(1056) -> {l_bs_get_integer_8, 2};
var_by_index(1057) -> {l_bs_get_integer_small_imm, 2};
var_by_index(1058) -> {l_hibernate, 0};
var_by_index(1059) -> {l_apply_fun_last, 0};
var_by_index(1060) -> {l_band, 2};
var_by_index(1061) -> {is_bigint, 0};
var_by_index(1062) -> {on_load, 0};
var_by_index(1063) -> {move2, 10};
var_by_index(1064) -> {l_bs_test_unit, 0};
var_by_index(1065) -> {l_m_div, 0};
var_by_index(1066) -> {l_select_val_smallints, 2};
var_by_index(1067) -> {is_function2, 0};
var_by_index(1068) -> {test_heap, 1};
var_by_index(1069) -> {func_info, 0};
var_by_index(1070) -> {call_bif, 0};
var_by_index(1071) -> {l_bs_get_utf16, 2};
var_by_index(1072) -> {l_put_tuple, 7};
var_by_index(1073) -> {allocate_init, 1};
var_by_index(1074) -> {l_call_fun_last, 1};
var_by_index(1075) -> {set_tuple_element, 2};
var_by_index(1076) -> {allocate_heap, 1};
var_by_index(1077) -> {is_tuple_of_arity, 4};
var_by_index(1078) -> {test_arity, 4};
var_by_index(1079) -> {l_bs_match_string, 4};
var_by_index(1080) -> {is_nonempty_list_allocate, 2};
var_by_index(1081) -> {l_bs_append, 2};
var_by_index(1082) -> {try_case_end, 1};
var_by_index(1083) -> {init3, 1};
var_by_index(1084) -> {l_select_tuple_arity2, 3};
var_by_index(1085) -> {init2, 1};
var_by_index(1086) -> {l_is_function2, 2};
var_by_index(1087) -> {l_bs_get_binary_all2, 2};
var_by_index(1088) -> {is_nonempty_list_test_heap, 1};
var_by_index(1089) -> {allocate_heap_zero, 1};
var_by_index(1090) -> {l_bs_init_heap_bin, 1};
var_by_index(1091) -> {l_plus, 3};
var_by_index(1092) -> {l_bs_get_integer, 1};

var_by_index(Index) -> erlang:error({novarat,Index}).

%%EOF



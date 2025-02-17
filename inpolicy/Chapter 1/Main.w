[Main::] Main.

The top level, which decides what is to be done and then carries
this plan out.

@h Main routine.

@e SILENCE_CLSW
@e VERBOSE_CLSW
@e PROBLEMS_CLSW
@e KIT_VERSIONS_CLSW
@e SYNC_KIT_VERSIONS_CLSW

=
pathname *path_to_inpolicy = NULL; /* where we are installed */
pathname *path_to_inpolicy_workspace = NULL; /* the materials pathname */
int return_happy = TRUE, silence_mode = FALSE, verbose_mode = FALSE;

int main(int argc, char **argv) {
	Foundation::start(argc, argv);
	
	CommandLine::declare_heading(
		L"[[Purpose]]\n\n"
		L"usage: inpolicy [options]\n");

	CommandLine::declare_switch(PROBLEMS_CLSW, L"check-problems", 1,
		L"check problem test case coverage");
	CommandLine::declare_switch(KIT_VERSIONS_CLSW, L"kit-versions", 1,
		L"show version numbers of the built-in kits");
	CommandLine::declare_switch(SYNC_KIT_VERSIONS_CLSW, L"sync-kit-versions", 1,
		L"fix version numbers of the built-in kits to match core inform7 version");

	CommandLine::declare_boolean_switch(SILENCE_CLSW, L"silence", 1,
		L"print nothing unless there's something wrong", FALSE);
	CommandLine::declare_boolean_switch(VERBOSE_CLSW, L"verbose", 1,
		L"explain what inpolicy is doing", FALSE);

	CommandLine::read(argc, argv, NULL, &Main::respond, &Main::disallow);

	path_to_inpolicy = Pathnames::installation_path("INPOLICY_PATH", I"inpolicy");
	path_to_inpolicy_workspace = Pathnames::down(path_to_inpolicy, I"Workspace");
	if (verbose_mode) PRINT("Installation path is %p\n", path_to_inpolicy);

	Foundation::end();
	if (return_happy) return 0; else return 1;
}

void Main::disallow(int id, text_stream *arg, void *state) {
	Errors::fatal("no arguments are allowed at the command line");
}

@

@d RUNTEST(Routine)
	path_to_inpolicy = Pathnames::installation_path("INPOLICY_PATH", I"inpolicy");
	path_to_inpolicy_workspace = Pathnames::down(path_to_inpolicy, I"Workspace");
	if (silence_mode) {
		if (Routine(NULL) == FALSE) { return_happy = FALSE; Routine(STDERR); }
	} else {
		if (Routine(STDOUT) == FALSE) return_happy = FALSE;
	}

=
void Main::respond(int id, int val, text_stream *arg, void *state) {
	switch (id) {
		case PROBLEMS_CLSW: RUNTEST(Coverage::check); break;
		case KIT_VERSIONS_CLSW: KitVersioning::show_versions(); break;
		case SYNC_KIT_VERSIONS_CLSW: KitVersioning::sync_versions(); break;
		case SILENCE_CLSW: silence_mode = val; break;
		case VERBOSE_CLSW: verbose_mode = val; break;
	}
}

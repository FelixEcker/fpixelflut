{$mode objfpc}
unit uShared;

{$H+}

interface

type
	TUInt8DynArray = array of UInt8;

	IRenderer = interface
		procedure Render;
	end;

	IRendererDynArray = array of IRenderer;

const
	{ Config }
	FONT_SIZE		= 80;
	LENGTH_SECONDS	= 60;
	SCROLL_TEXT		= 'Begrüßung! We like to färenmachen! We like gay telephoncells and cities of the gayish type :3 You, know ?! When will the färenmacher come to the deutschepost-linux from the telephone cell? We dont know either! Greetings to cool people present and not here (by cool we mean not transphobic or any other bad thing (so not trsi :3333)). We made the driving here (partly) with the RE34 direction siegen and telephonecell. telephonecell. cell. sell? sellout? epoqe has sold out? THATS RIGHT! they suck now. yes. Goodbye :)';
	SCROLL_SPEED	:	Int64	= 12;
	BOAT_SPEED		:	Real	= 0.5;
	WAVE_DIVISOR	:	Real	= 5;
	WAVE_MULTIPLIER	:	Real	= 3;

	BOAT_WIDTH_DIVISOR	: Real = 3;
	BOAT_HEIGHT_DIVISOR	: Real = 3;

	SCREEN_WIDTH	: Real = 1920;
	SCREEN_HEIGHT	: Real = 1080;

	{ Exit Codes }
	ERROR_EXIT_GEN	= 001;
	ERROR_EXIT_RES	= 100;
	ERROR_EXIT_ALSA	= 110;
	ERROR_EXIT_GL	= 120;

implementation

end.

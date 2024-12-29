{$mode objfpc}
unit uBMP;

interface

uses classes, elfreader, resource, sysutils, uShared;

type
	{$PACKRECORDS 1}
	TBMPHeader = packed record
		header		: UInt16;
		size		: UInt32;
		__res1		: UInt16; { Reserved Field }
		__res2		: UInt16; { Reserved Field }
		data_offset	: UInt32;
	end;

	TBITMAPINFOHEADER = packed record
		header_size		: UInt32;
		width			: UInt32;
		height			: UInt32;
		color_planes	: UInt16;
		bits_per_pixel	: UInt16;
	end;
	{$PACKRECORDS DEFAULT}

	TTexture = record
		width	: Integer;
		height	: Integer;
		data	: TUInt8DynArray;
	end;

function LoadTexture(const resource: TAbstractResource): TTexture;

implementation

function LoadTexture(const resource: TAbstractResource): TTexture;
var
	raw_header		: array [0..13] of UInt8;
	raw_dib_header	: array [0..15] of UInt8;
	raw_pixel_buff	: TUInt8DynArray;

	raw_pixel_buff_size : UInt32;

	header		: TBMPHeader absolute raw_header;
	dib_header	: TBITMAPINFOHEADER absolute raw_dib_header;

	read_count : Integer;

	new_texture : TTexture;
begin
	{ Try to parse the Bitmap }

	read_count := 0;
	read_count := resource.rawdata.read(raw_header, Length(raw_header));

	if read_count <> Length(raw_header) then
	begin
		writeln(
			'LoadTexture: ERROR: BMP Header Length mismatch! expected ',
			Length(raw_header),
			' bytes, got ',
			read_count
		);
		halt(1);
	end;

	{ Header bytes are in reverse order because of endianess }

	if header.header <> $4D42 then
	begin
		writeln('[uBMP] LoadTexture: ERROR: BMP Header does not contain a ',
				'valid header-field!');
		halt(1);
	end;

	read_count := resource.rawdata.read(raw_dib_header, Length(raw_dib_header));
	if read_count <> Length(raw_dib_header) then
	begin
		writeln(
			'LoadTexture: ERROR: BMP Header Length mismatch! expected ',
			Length(raw_dib_header),
			' bytes, got ',
			read_count
		);
		halt(1);
	end;

	raw_pixel_buff_size :=	(dib_header.bits_per_pixel div 8)
							* dib_header.width
							* dib_header.height;
	SetLength(raw_pixel_buff, raw_pixel_buff_size);

{$IFNDEF NOLOG}
	writeln(
		'[uBMP] LoadTexture: IMG dimensions ',
		dib_header.width, 'x', dib_header.height
	);
	writeln(
		'[uBMP] LoadTexture: Pixel Data starts at ', header.data_offset
	);
	writeln(
		'[uBMP] LoadTexture: Pixel Data size is ',
		raw_pixel_buff_size, ' bytes'
	);
	writeln('[uBMP] LoadTexture: Bits per Pixel ', dib_header.bits_per_pixel);
{$ENDIF}

	resource.rawdata.seek(header.data_offset, soFromBeginning);
	resource.rawdata.readbuffer(raw_pixel_buff[0], raw_pixel_buff_size);

	new_texture.data	:= raw_pixel_buff;
	new_texture.width	:= dib_header.width;
	new_texture.height	:= dib_header.height;

	result := new_texture;
end;

end.

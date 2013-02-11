package
{
    public class AssetEmbeds
    {
        // Bitmaps
		[Embed(source = "../media/textures/player.png")]
		public static const PlayerImage:Class;
		
		//STARLING:
        
        [Embed(source = "../media/textures/background.png")]
        public static const Background:Class;
        
        [Embed(source = "../media/textures/starling_sheet.png")]
        public static const StarlingSheet:Class;
        
        [Embed(source = "../media/textures/starling_round.png")]
        public static const StarlingRound:Class;
        
        [Embed(source = "../media/textures/starling_front.png")]
        public static const StarlingFront:Class;
        
        [Embed(source = "../media/textures/starling_rocket.png")]
        public static const StarlingRocket:Class;
        
        [Embed(source = "../media/textures/logo.png")]
        public static const Logo:Class;
        
        [Embed(source = "../media/textures/button_back.png")]
        public static const ButtonBack:Class;
        
        [Embed(source = "../media/textures/button_big.png")]
        public static const ButtonBig:Class;
        
        [Embed(source = "../media/textures/button_normal.png")]
        public static const ButtonNormal:Class;
        
        [Embed(source = "../media/textures/button_square.png")]
        public static const ButtonSquare:Class;
        
        [Embed(source = "../media/textures/benchmark_object.png")]
        public static const BenchmarkObject:Class;
        
        [Embed(source = "../media/textures/brush.png")]
        public static const Brush:Class;
        
        // Compressed textures
        
        [Embed(source = "../media/textures/compressed_texture.atf", mimeType="application/octet-stream")]
        public static const CompressedTexture:Class;
        
        // Texture Atlas
        
        [Embed(source="../media/textures/atlas.xml", mimeType="application/octet-stream")]
        public static const AtlasXml:Class;
        
        [Embed(source="../media/textures/atlas.png")]
        public static const AtlasTexture:Class;
        
        // Bitmap Fonts
        
        [Embed(source="../media/fonts/desyrel.fnt", mimeType="application/octet-stream")]
        public static const DesyrelXml:Class;
        
        [Embed(source = "../media/fonts/desyrel.png")]
        public static const DesyrelTexture:Class;
    }
}
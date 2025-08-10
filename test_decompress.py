import base64
import gzip
import json

# The compressed data from your main.dart
compressed_b64 = "H4sIAAAAAAAC/02LQQ7CIBBF7zLrpkBClbDyDrozLqCAkkAlpTGQpnd3Ztfd+2/e7PADDWLkMECIDtk3k0vylTmzbqx8K0vRsmziMpK5TUHOl5kbeijY148R+iSTWd6oqcVVewb9fA3QVh8q6P0YILqGALbf6UjG9kcvnhjHhpm4TlJxpaQ8/m8zPGKiAAAA"

try:
    # Decode base64
    compressed_data = base64.b64decode(compressed_b64)
    
    # Decompress gzip
    decompressed_data = gzip.decompress(compressed_data)
    
    # Parse JSON
    anchor_data = json.loads(decompressed_data.decode('utf-8'))
    
    print("🔍 Embedded Anchor Header Contents:")
    print(f"Version: {anchor_data.get('v', 'unknown')}")
    print(f"File ID: {anchor_data.get('fid', 'unknown')}")
    print(f"Language: {anchor_data.get('lang', 'unknown')}")
    print(f"Symbols Count: {len(anchor_data.get('sym', []))}")
    print(f"Cross-references: {len(anchor_data.get('xrefs', {}))}")
    
    if anchor_data.get('sym'):
        print("\nSymbols found:")
        for i, sym in enumerate(anchor_data['sym'][:5]):  # Show first 5
            print(f"  {i+1}. {sym.get('n', 'unnamed')} ({sym.get('k', 'unknown')})")
    else:
        print("\n❌ NO SYMBOLS FOUND - This confirms the extraction issue\!")
        
except Exception as e:
    print(f"Error decompressing: {e}")

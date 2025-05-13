An ImageJ/Fiji Macro (.ijm) that automates the analysis of alginate bead images. It guides you through a simple UI to select input images and parameters, processes each image to isolate beads, and outputs a results table containing key metrics (area, circularity, roundness, major/minor axis lengths, etc.).

🚀 Features
Interactive UI
Prompts you to:

Select one or more bead images (TIFF/PNG/JPG)

Choose an output folder

Configure processing parameters (threshold method, size filter)

Automated Bead Detection
Applies background subtraction, thresholding, and morphological operations to isolate beads.

Comprehensive Metrics
Measures per‐bead:

Area

Perimeter

Circularity

Roundness

Major (longest) diameter

Minor (orthogonal) diameter

Feret’s diameter

Batch Processing
Analyzes an entire folder of images in one run—no manual ROI selection required.

Results Export
Generates a CSV file (bead_analysis_results.csv) with one row per bead and columns for each measured metric.

📦 Requirements
Fiji (ImageJ bundled) (latest version recommended)

No additional plugins beyond Fiji’s built‐ins

Usage:
1. Download and open ImageJ Fiji
2. Drag and drop 'Analysis.ijm' file to ImageJ Fiji
3. Click 'run' and a UI with further prompts should pop-up with clear instructions

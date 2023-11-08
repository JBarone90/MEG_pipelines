# MEG Analysis Project

Welcome to the MEG Analysis Project repository! Here, I provide a set of modular pipelines for analyzing Magnetoencephalography (MEG) data, a non-invasive method for investigating human brain activity.

## Current Pipelines

- **Meg_Preprocessing_Main**:
  A semi-automated pipeline for preprocessing MEG CTF data, which includes steps such as:

  - Data Filtering
  - Epoching
  - Downsampling
  - Artifact removal using Independent Component Analysis (ICA)
  - Bad trial rejection based on z-score thresholding

- **Meg_Forward_Model_Main**:
  A semi-automated pipeline for building a head volume conduction model, essential for source estimation in MEG analysis. Steps include:

  - MRI reading and co-registration
  - Head model creation
  - Lead field computation

## Usage Instructions

1. Clone this repository to your local machine.
2. Add the cloned repository's path to your MATLAB environment.
3. Execute the desired pipeline scripts located within the `/matlab/main` directory.

## Dependencies

- [FieldTrip Toolbox](http://www.fieldtriptoolbox.org/) (version 20190219; not tested with newer versions)
- MATLAB (developed with version 9.3.0.713579 (R2017b); compatibility with later versions is not guaranteed)

## Upcoming Features

- Implementation of Source Localization
- Extension to Time-Frequency Analysis
- Inclusion of Connectivity Analysis
- Development of a Python counterpart using MNE (More details on the timeline for these features will be provided)

## License

This project is open-source and released under the [MIT License](LICENSE.md).

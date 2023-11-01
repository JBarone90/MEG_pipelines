# MEG Analysis Project

Welcome to the MEG Analysis Project repository! This is a comprehensive collection of modular pipelines designed for the analysis of Magnetoencephalography (MEG) data.

## Current Pipelines

- **Meg_Preprocessing_Main**: This is a semi-automated pipeline tailored for the preprocessing of MEG CTF data. It encompasses various steps including but not limited to:
  - Data Filtering
  - Epoching
  - Downsampling
  - Independent Component Analysis (ICA) for artifact removal
  - Rejection of bad trials based on artifact detection

## Usage Instructions

1. Clone the repository.
2. Add the repository to your MATLAB path.
3. Run the scripts in the `/matlab/main` folder.

## Dependencies

- FieldTrip Toolbox (version 20190219; not tested with newer ones)
- MATLAB

## Upcoming Features

- Source Localization
- Time-Frequency Analysis
- Connectivity Analysis
- Python implementation (using MNE)

## License

This project is open source and available under the MIT License. For more details, please refer to the [LICENSE.md](LICENSE.md) file.

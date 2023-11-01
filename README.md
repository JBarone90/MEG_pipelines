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

1. **Clone the Repository**: Use `git clone` to download the codebase to your local machine.
2. **Set MATLAB Path**: Add the repository's root directory to your MATLAB path.
3. **Run Scripts**: Execute the necessary scripts located in the `/main` folder to perform MEG data analysis.

## Dependencies

- FieldTrip Toolbox (Tested with version 20190219; compatibility with newer versions is not guaranteed)
- MATLAB

## Upcoming Features

- Source Localization
- Time-Frequency Analysis
- Connectivity Analysis
- Python implementation (using MNE)

## License

This project is open source and available under the MIT License. For more details, please refer to the [LICENSE.md](LICENSE.md) file.

# Mg_infusion_coma

## 주의사항
코드에서 필요한 raw file들은 로컬에 저장되어 있음.
컴퓨터 환경에 맞는 절대경로를 확인해서 입력해야 함.

## 중요 파일
`README.md`
- 프로젝트에 대한 설명을 담은 Markdown 문서

`preprocessing_gamma.ipynb`
- Input: edf format의 raw EEG ('edf_fif_pre_post' 폴더)
- raw EEG를 로드하고
- filter, notch filter, monopolar 변환, ICA 시행
- **1-90Hz** 주파수 대역에서 분석 시행
- Ouput: fif format의 clean EEG (파일명 맨 뒤에 gamma 붙어있음)

`preprocessing.ipynb`
- Input: edf format의 raw EEG ('edf_fif_pre_post' 폴더)
- raw EEG를 로드하고
- filter, notch filter, monopolar 변환, ICA 시행
- **1-30Hz** 주파수 대역에서 분석 시행
- Ouput: fif format의 clean EEG

`tfr.ipynb`
- Input: fif format의 clean EEG ('edf_fif_pre_post' 폴더)
- clean EEG를 로드하고
- TFR을 시행
  1. (`preprocessing`의 output에 대하여) 모든 주파수대역을 한 번에 TFR 계산하여 저장 ('tfr_files_pre_post' 폴더)
  2. (`preprocessing_gamma`의 output에 대하여) 주파수 대역을 delta, theta, alpha, beta, gamma1, gamma2로 나누어서 TFR 계산하여 저장 ('tfr_files_freq_pre_post' 폴더)
- Output: h5 format의 rawTFR

`analysis_gamma.ipynb`
- Input: 대역별로 나눠서 계산된 rawTFR ('tfr_files_freq_pre_post' 폴더)
- 대역별로 TFR을 로딩하여
- 각각의 power value를 계산하여 저장
- Output: Mg_infusion_data.xlsx의 데이터

`analysis_24h.ipynb`
- Input: 24h-infusion에서 추출한 edf format의 raw EEG data ('edf_fif_24h' 폴더)
- raw EEG 로드하여
- preprocessing 하여 fif format의 clean EEG 저장하고 ('edf_fif_24h' 폴더)
- 주파수 대역별로 나눠서 TFR 계산하고 h5 format으로 rawTFR 저장하고 ('tfr_files_freq_24h' 폴더')
- 각각의 power value를 계산하여 저장
- Output: Mg_infusion_data.xlsx의 데이터

`CDSA_plotting.ipynb`
- Input: 1-30Hz까지 한 번에 계산된 rawTFR ('tfr_files_pre_post' 폴더)
- TFR 로딩하여
- plot_1108 결과인 CDSA 파일 생성
- Output: CDSA plot (CDSA plot > plot_1108)

`figure_and_table.ipynb`
- 논문 작성 중 필요한 figure와 table 생성하는 코드

`requirements.txt`
- 본 코드를 돌리기 위해서 필요한 패키지들

## 중요하지 않은 파일

`analysis.ipynb`
- Input: 1-30Hz의 rawTFR ('tfr_files_pre_post' 폴더에 위치한 파일) -> **gamma 대역까지 분석을 확장하면서 폐기됨**
- TFR을 로딩하여
- 각각의 power value를 계산하여 저장
- Output: Mg_infusion_data.xlsx의 데이터

`plotting.ipynb`
- Input: rawTFR 파일
- TFR 데이터를 불러와 평균해준 후
- CDSA, time-power plot 등 여러 plot 생성하는 코드 -> **탐색적 목적의 다양한 플롯 존재**
- Ouput: 다양한 plot

`example.ipynb`
- 공개할 예시 데이터 생성 코드

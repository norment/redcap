# MultiSense Hub-Node

**Concepts, tooling, and workflows for secure multimodal
research data management in TSD**

> **Note:** MultiSense Hub-Node is a research and development initiative.  
> It does **not** constitute a centrally operated or general-purpose service on TSD.  
> The repository provides software, configuration examples, and documentation
> that projects may adapt in collaboration with their local IT/TSD contacts.

------------------------------------------------------------------------

## Important links

* For step-by-step instructions about installing REDCap on TSD, see [INSTALL.md](INSTALL.md)
* If you face any issues with this repository, open a new GitHub issue [here](https://github.com/norment/redcap/issues)
* For official information from USIT TSD, see [here](https://www.uio.no/english/services/it/research/sensitive-data/help/software/redcap.html)
* For an in-depth overview of REDCap functionality, see https://project-redcap.org/ or join the [REDCap community](https://projectredcap.org/resources/community/)

## Container tooling

Deployment on TSD uses `podman`. Local development (building images and testing) should use `docker`.
See [INSTALL.md](INSTALL.md) for deployment details and [CONTRIBUTING.md](CONTRIBUTING.md) for image build/publish steps.

## Overview

MultiSense Hub-Node is an initiative designed to explore and support approaches for researchers
using University of Oslo's Services for Sensitive Data (TSD) for collecting
and organizing **sensitive, multimodal datasets**—including clinical,
genetic, neuroimaging, registry, and socio-economic information—by
providing standardized, reproducible, and user-friendly data
infrastructure patterns and tooling.

The project focuses on enabling **secure data organization,
harmonization, quality assurance, and analysis workflows** within TSD,
while ensuring compliance with legal,
ethical, and security requirements for handling protected research data.

This work is intended to conceptually complement Nettskjema on TSD, which is used for secure data collection,
by offering patterns for organizing already collected data and linking complex multimodal datasets 
into a coherent resource within a TSD project.

------------------------------------------------------------------------

## Project Scope

MultiSense aims to help address key challenges in modern data-intensive research:

-   Integration of **heterogeneous multimodal data sources**
-   Standardization and **harmonization across studies and formats**
-   Reproducible and **scalable analytical workflows**
-   Secure handling of **person-sensitive information**
-   Improved **data quality control and metadata organization**
-   Readiness for **distributed and collaborative analyses** across
    infrastructures

By operationalizing and documenting these capabilities in TSD,
the project aims to make advanced data management and analysis
**conceptually accessible to a broad range of research users**, independent of technical background.

------------------------------------------------------------------------

## REDCap in MultiSense

A central component of the hub is **REDCap (Research Electronic Data
Capture)**, a widely used secure web-based platform for managing
research data.

Key characteristics of REDCap:

-   Used by **thousands of institutions worldwide** for clinical and
    research data capture
-   Provides **role-based access control**, audit trails, and secure
    data handling
-   Supports **structured data collection, validation, and real-time
    quality checks**
-   Enables **direct export** to common analysis environments (e.g., R,
    Python, SPSS)
-   Facilitates **integration of questionnaire data, clinical variables,
    imaging metadata, and omics data**
-   Aligns with **regulatory, legal, and interoperability standards**
    for sensitive research data

Within MultiSense, REDCap is used as a **core database layer** in example
deployments to curate, connect, and prepare multimodal datasets for downstream
statistical analysis and machine learning.

------------------------------------------------------------------------

## What the Hub Develops

MultiSense Hub-Node develops and documents:

1.  **REDCap-based deployment patterns in TSD**
    -   Secure storage and structured organization of multimodal data
    -   Tools and examples for curation, validation, and quality assurance
    -   Integration with questionnaire-based data collection workflows
    -   User-oriented configurations for non-technical researchers

2.  **Multimodal data linkage and harmonization approaches**
    -   Example connections of genetics, imaging, clinical, and registry data
    -   Metadata organization aligned with national and international
        standards, where applicable
    -   Support for reproducible and distributed analyses through shared practices

3.  **Training materials, documentation, and examples**
    -   Written guides and example research workflows
    -   Suggestions for workshops and user meetings
    -   Contributions to community knowledge around multimodal data handling in TSD

> These assets are intended as building blocks and examples.  
> They do **not** in themselves constitute a centrally managed service for end users.

------------------------------------------------------------------------

## Operational Goal

The primary objective is to **develop and document operational models and tooling
for MultiSense-like workflows within TSD**, so that secure multimodal database infrastructure can be:

-   **Adapted by interested research projects** in collaboration with TSD/USIT
-   **Sustained beyond initial funding** through reusable procedures and materials
-   **Extended to national and international collaborations** where local governance allows

------------------------------------------------------------------------

## Intended Use Cases

MultiSense is conceptually targeted at:

-   Researchers handling **sensitive human data**
-   Projects requiring **multimodal data integration**
-   Teams needing **secure databases and reproducible workflows**
-   Users seeking **accessible tools without extensive IT
    specialization**

These are **example use cases**, not an indication of an automatically available service.

------------------------------------------------------------------------

## Sustainability

The hub emphasizes:

-   **Documented installation and operational procedures**
-   Reusable **training materials and course content**
-   Community-driven **knowledge sharing and contributions**
-   Continued **evolution of practices within TSD infrastructure**

The aim is to support long-term availability of secure multimodal data management
methods and tooling for the research community, without implying a specific
centrally operated service.

------------------------------------------------------------------------

## Repository Purpose

This repository serves as the **root entry point** for:

-   Documentation of the MultiSense Hub-Node concepts and tooling
-   Deployment and operational guidance for example setups
-   Training materials and example workflows
-   Resources for researchers interested in using REDCap and related tools within TSD

FROM images.home.mtaylor.io/base

ENV ARGOCD_URL=https://argocd.mtaylor.io/download/argocd-linux-amd64

ENV KUBECTL_VERSION=v1.28.4
ENV KUBECTL_URL=https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl

ENV KUSTOMIZE_VERSION=v5.3.0
ENV KUSTOMIZE_REPO=https://github.com/kubernetes-sigs/kustomize
ENV KUSTOMIZE_RELEASE=${KUSTOMIZE_REPO}/releases/download/kustomize%2F${KUSTOMIZE_VERSION}
ENV KUSTOMIZE_FILENAME=kustomize_${KUSTOMIZE_VERSION}_linux_amd64.tar.gz
ENV KUSTOMIZE_URL=${KUSTOMIZE_RELEASE}/${KUSTOMIZE_FILENAME}
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
  && apt-get upgrade -y \
  && apt-get install -y curl git yq \
  && rm -rf /var/lib/apt/lists/* \
  && apt-get clean

RUN curl -LfO ${ARGOCD_URL} \
  && install -T -m 0755 argocd-linux-amd64 /usr/local/bin/argocd \
  && rm -f argocd-linux-amd64

RUN curl -LfO ${KUBECTL_URL} \
  && install -t /usr/local/bin/ -m 0755 kubectl \
  && rm -f kubectl

RUN curl -Lf ${KUSTOMIZE_URL} | tar -xz \
  && install -t /usr/local/bin/ kustomize \
  && rm -f kustomize

ADD branch-name-for-tag /usr/local/bin/branch-name-for-tag
ADD get-release-tag /usr/local/bin/get-release-tag
